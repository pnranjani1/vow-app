class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer  :invoice_number
      t.datetime :bill_date
      t.integer :customer_id
      t.integer :product_id
      t.integer :user_id
      t.integer :quantity

      t.timestamps
    end
  end
end
