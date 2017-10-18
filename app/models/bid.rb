class Bid < ApplicationRecord
  belongs_to :lot

  validates :amount, presence: true, numericality: true
  validate :amount_larger_than_previous_bid

  private

  def amount_larger_than_previous_bid
    return true if lot.bids.none?
    return true if amount > lot.bids.last.amount

    errors.add(:amount, 'has to be larger then previous bid')
  end
end
