class CreateCheckoutRecords < ActiveRecord::Migration
  def change
    create_table :checkout_records do |t|
      t.integer :book_id
      t.integer :user_id

      t.timestamps
    end
  end
end
