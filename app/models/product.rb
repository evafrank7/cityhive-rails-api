class Product
  include Mongoid::Document # Product is a document stored in MongoDB

  field :name, type: String
  field :category, type: String
  field :description, type: String
  field :price_cents, type: Integer # Confirming that prices are stored in cents to avoid floating-point issues
  field :inventory_count, type: Integer, default: 0
  field :active, type: Mongoid::Boolean, default: true # Indicates if a product is active and is available for sale

  validates :name, presence: true
  validates :category, presence: true
  validates :price_cents, presence: true,
                          numericality: { greater_than_or_equal_to: 0 } # price cannot be a negative value
  validates :inventory_count, presence: true,
                              numericality: { greater_than_or_equal_to: 0 } # inventory count cannot be negative
end
