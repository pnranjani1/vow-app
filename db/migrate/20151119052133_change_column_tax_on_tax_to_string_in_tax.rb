class ChangeColumnTaxOnTaxToStringInTax < ActiveRecord::Migration
  def change
    change_column :taxes, :tax_on_tax, :string
  end
end
