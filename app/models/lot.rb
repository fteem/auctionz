class Lot < ApplicationRecord
  belongs_to :auction
  has_many :bids
end
