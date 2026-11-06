
class Order
  include Mongoid::Document

  # Every attribute in the order is defined as a field in the MongoDB document.
  field :email, type: String
  field :status, type: String, default: "completed"
  field :items, type: Array, default: []
  field :tax_cents, type: Integer, default: 0
  field :total_cents, type: Integer, default: 0

  validates :email, presence: true
  validates :items, presence: true
  validates :status, inclusion: { in: ["completed"] }

  validates :tax_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :total_cents, numericality: { greater_than_or_equal_to: 0 }
end
