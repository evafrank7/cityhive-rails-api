require "test_helper"

class CheckoutsTest < ActionDispatch::IntegrationTest
  setup do
    Product.delete_all
    Order.delete_all

    @product = Product.create!(
      name: "Test T-Shirt",
      category: "Clothing",
      description: "A test product",
      price_cents: 2500,
      inventory_count: 10,
      active: true
    )
  end

  test "returns a valid checkout quote" do
    post "/checkout/quote", params: {
      items: [
        { product_id: @product.id.to_s, quantity: 2 }
      ]
    }, as: :json

    assert_response :success

    body = JSON.parse(response.body)

    assert_equal 5000, body["subtotal_cents"]
    assert_equal 400, body["tax_cents"]
    assert_equal 5400, body["total_cents"]
  end

  test "rejects an empty cart" do
    post "/checkout/quote", params: {
      items: []
    }, as: :json

    assert_response :bad_request

    body = JSON.parse(response.body)

    assert_equal "Cart is empty", body["error"]
  end
  test "completes checkout and updates inventory" do
    post "/checkout/complete", params: {
      email: "test@example.com",
      items: [
        { product_id: @product.id.to_s, quantity: 2 }
      ]
    }, as: :json

    assert_response :created

    body = JSON.parse(response.body)

    assert_equal 5400, body["total_cents"]
    assert body["order_id"].present?

    order = Order.find(body["order_id"])

    assert_equal "test@example.com", order.email
    assert_equal "completed", order.status
    assert_equal 5400, order.total_cents

    # Reload the product to read its updated inventory from MongoDB.
    assert_equal 8, @product.reload.inventory_count
  end
end
