10.times do
  Auction.create(name: Faker::Commerce.material)
end

100.times do
  auction = Auction.all.take
  Lot.create(name: Faker::Commerce.product_name, auction: auction)
end
