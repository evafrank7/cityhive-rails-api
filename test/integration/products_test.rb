require "test_helper"

class ProductsTest < ActionDispatch::IntegrationTest
  setup do
    Product.delete_all

    Product.create!(
      name: "Test T-Shirt",
      category: "Clothing",
      description: "A test product",
      price_cents: 2500,
      inventory_count: 10,
      active: true
    )

    Product.create!(
      name: "Inactive Hoodie",
      category: "Clothing",
      description: "An inactive product",
      price_cents: 4500,
      inventory_count: 5,
      active: false
    )
  end

  test "returns only active products" do
    get "/products"

    assert_response :success

    response_body = JSON.parse(response.body)

    assert_equal 1, response_body["products"].length
    assert_equal "Test T-Shirt", response_body["products"][0]["name"]
  end

  test "filters products by category" do
    get "/products", params: { category: "Clothing" }
  
    assert_response :success
  
    response_body = JSON.parse(response.body)
  
    assert_equal 1, response_body["products"].length
    assert_equal "Test T-Shirt", response_body["products"][0]["name"]
  end
  
  test "returns 404 for a missing product" do
    get "/products/000000000000000000000000"
  
    assert_response :not_found
  
    response_body = JSON.parse(response.body)
  
    assert_equal "Resource not found", response_body["error"]
  end
end