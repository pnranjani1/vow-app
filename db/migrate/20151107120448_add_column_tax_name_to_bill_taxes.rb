class AddColumnTaxNameToBillTaxes < ActiveRecord::Migration
  def change
    add_column :bill_taxes, :tax_name, :string
  end
end
