class AddBooleanColumnToBills < ActiveRecord::Migration
  def change
    remove_column :bills, :invoice_number_format
    add_column :bills, :instant_invoice_format, :string
  end
end
