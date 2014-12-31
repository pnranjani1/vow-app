class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :tin_number
      t.string :phone_number
      t.string :address
      t.string :city
      t.integer :user_id


      t.timestamps
    end
  end
end
