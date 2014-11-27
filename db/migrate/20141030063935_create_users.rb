class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :tin_number
      t.string :address
      t.string :city
      t.string :phone_number
      t.integer :bank_account_number
      t.string :ifsc_code
      t.timestamps
    end
  end
end
