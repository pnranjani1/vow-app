class CreateBankdetails < ActiveRecord::Migration
  def change
    create_table :bankdetails do |t|
      t.integer :authuser_id
      t.integer :bank_account_number
      t.string :ifsc_code

      t.timestamps
    end
  end
end
