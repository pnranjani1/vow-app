class CreateInvoiceNumbers < ActiveRecord::Migration
  def change
    create_table :invoice_numbers do |t|
      t.string :number
      t.integer :bill_id
      t.integer :authuser_id
      t.timestamps
    end
  end
end
