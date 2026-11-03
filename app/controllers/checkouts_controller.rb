class CheckoutsController < ApplicationController
  def quote
    render json: build_cart # Calls private method build_cart which handles all calculations in cart
  end

  def complete
    cart = build_cart

    # Creates the order
    order = Order.create!(
      email: checkout_params[:email],
      status: "completed",
      items: cart[:items],
      tax_cents: cart[:tax_cents],
      total_cents: cart[:total_cents] # Price in cents, avoids floating point issues w/ currencies
    )

    # Updates the inventory count for each product in the order
    cart[:items].each do |item|
      product = Product.find(item[:product_id])

      product.inventory_count -= item[:quantity] # Subtracts total count of items purchased from the inventory count
      product.save!
    end

    render json: {
      order_id: order.id.to_s,
      total_cents: order.total_cents
    }, status: :created
  end

  private

  def build_cart
    items = checkout_params[:items] || [] # Create an array of items using checkout_params, none if nothing is present.

    raise ActionController::BadRequest, "Cart is empty" if items.empty?

    # Query the product model to find all the products that match the ids in the array of items.
    products = Product.where(
      :id.in => items.map { |item| item[:product_id] }
    ).index_by { |product| product.id.to_s }

    line_items = items.map do |item|    
      product = products[item[:product_id]]

      raise ActionController::BadRequest, "Product not found" unless product

      quantity = item[:quantity].to_i

      raise ActionController::BadRequest, "Invalid quantity" if quantity <= 0
      raise ActionController::BadRequest, "Insufficient inventory" if product.inventory_count < quantity

      {
        product_id: product.id.to_s,
        name: product.name,
        quantity: quantity,
        unit_price_cents: product.price_cents,
        total_cents: product.price_cents * quantity
      }
    end

    # Calculate subtotal, tax, and total for the cart 
    subtotal_cents = line_items.sum { |item| item[:total_cents] }
    tax_cents = (subtotal_cents * 0.08).round

    {
      items: line_items,
      subtotal_cents: subtotal_cents,
      tax_cents: tax_cents,
      total_cents: subtotal_cents + tax_cents
    }
  end

  def checkout_params 
    params.permit(
      :email,
      items: [
        :product_id,
        :quantity
      ]
    )
  end
end