class CreateUserprofiles < ActiveRecord::Migration
  def change
    create_table :userprofiles do |t|
      
      t.string :tin_number
      t.string :phone_number
      t.datetime :membership_start_date
      t.datetime :membership_end_date
      t.string :membership_status
      t.integer :bank_account_number
      t.string :ifsc_code
      t.timestamps
    end
  end
end
