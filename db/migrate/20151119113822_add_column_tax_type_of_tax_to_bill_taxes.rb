class AddColumnTaxTypeOfTaxToBillTaxes < ActiveRecord::Migration
  def change
    add_column :bill_taxes, :tax_type_of_tax, :string
  end
end
