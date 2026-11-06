
products = [
  {
    name: "Hanes Cropped T-Shirt",
    category: "Clothing",
    description: "Comfortable cotton t-shirt",
    price_cents: 2500,
    inventory_count: 20,
    active: true
  },
  {
    name: "Black Heels",
    category: "Footwear",
    description: "Casual black heels to go with jeans or even can be dressed up.",
    price_cents: 7500,
    inventory_count: 15,
    active: true
  },
  {
    name: "Leather Purse",
    category: "Accessories",
    description: "Dark brown leather purse",
    price_cents: 1800,
    inventory_count: 30,
    active: true
  },
  {
    name: "Vintage Denim Jacket",
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
