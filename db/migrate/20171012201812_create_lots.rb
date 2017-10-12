class CreateLots < ActiveRecord::Migration[5.1]
  def change
    create_table :lots do |t|
      t.string :name
      t.references :auction

      t.timestamps
    end
  end
end
