class AddColumnTaxAmountToBillTaxes < ActiveRecord::Migration
  def change
    add_column :bill_taxes, :tax_amount, :float
  end
end
