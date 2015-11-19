class CreateBillTaxes < ActiveRecord::Migration
  def change
    create_table :bill_taxes do |t|

      t.integer :bill_id
      t.integer :tax_id
      t.timestamps
    end
  end
end
