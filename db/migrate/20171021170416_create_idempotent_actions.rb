class CreateIdempotentActions < ActiveRecord::Migration[5.1]
  def change
    create_table :idempotent_actions do |t|
      t.string :idempotency_key
      t.string :body # should be JSON, for non-sqlite3 datastores
      t.integer :status
      t.string :headers # should be JSON, for non-sqlite3 datastores

      t.timestamps
    end
  end
end
