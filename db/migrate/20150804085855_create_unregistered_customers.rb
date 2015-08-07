class CreateUnregisteredCustomers < ActiveRecord::Migration
  def change
    create_table :unregistered_customers do |t|
      t.string :customer_name
      t.string :phone_number
      t.string :address
      t.string :city
      t.integer :authuser_id
      t.timestamps
    end
  end
end
