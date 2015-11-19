class CreateBillOtherCharges < ActiveRecord::Migration
  def change
    create_table :bill_other_charges do |t|
       
      t.integer :bill_id
      t.integer :other_charges_information_id
      t.timestamps
    end
  end
end
