class Bid < ApplicationRecord
  belongs_to :lot
  belongs_to :user

  validates :amount, presence: true, numericality: true
end
