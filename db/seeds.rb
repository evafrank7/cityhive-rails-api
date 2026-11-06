
products = [
  {
    name: "Classic T-Shirt",
    category: "Clothing",
    description: "Comfortable cotton t-shirt",
    price_cents: 2500,
    inventory_count: 20,
    active: true
  },
  {
    name: "Running Sneakers",
    category: "Footwear",
    description: "Lightweight everyday sneakers",
    price_cents: 7500,
    inventory_count: 15,
    active: true
  },
  {
    name: "Canvas Tote Bag",
    category: "Accessories",
    description: "Reusable canvas tote bag",
    price_cents: 1800,
    inventory_count: 30,
    active: true
  },
  {
    name: "Discontinued Hoodie",
    category: "Clothing",
    description: "No longer available",
    price_cents: 4500,
    inventory_count: 0,
    active: false
  }
]

products.each do |attributes|
  product = Product.find_or_initialize_by(name: attributes[:name])
  product.assign_attributes(attributes)
  product.save!
end

puts "Seeded #{Product.count} products"
