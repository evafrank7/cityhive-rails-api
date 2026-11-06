class ProductsController < ApplicationController
  # Lists active products with filtering, searching, and pagination
  def index
    # Fetches the page and limit parameters and ensures they are within valid ranges.
    page = [ params.fetch(:page, 1).to_i, 1 ].max
    limit = [ [ params.fetch(:limit, 25).to_i, 100 ].min, 1 ].max

    # Filters the products based on the provided parameters. Only active products are considered.
    products = Product.where(active: true)

    products = products.where(category: params[:category]) if params[:category].present?

    # Search for products by name
    if params[:query].present?
      products = products.where(
        name: /#{Regexp.escape(params[:query])}/i # case insensitive regex search
      )
    end

    total_count = products.count

    products = products.order_by(name: :asc) # Sorts by product name in ascending order
                       .skip((page - 1) * limit)
                       .limit(limit)

    # Renders the products and pagination as JSON
    render json: {
      products: products.map { |product| serialize_product(product) },
      pagination: {
        page: page,
        limit: limit,
        total_count: total_count
      }
    }
  end

  def show
    product = Product.where(active: true).find(params[:id])

    render json: serialize_product(product)
  end

  private

  def serialize_product(product)
    {
      id: product.id.to_s,
      name: product.name,
      category: product.category,
      description: product.description,
      price_cents: product.price_cents,
      inventory_count: product.inventory_count
    }
  end
end
