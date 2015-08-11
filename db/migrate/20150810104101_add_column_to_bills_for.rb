class AddColumnToBillsFor < ActiveRecord::Migration
  def change
    add_column :bills, :invoice_number_format, :string
  end
end
