class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.references :lot, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
