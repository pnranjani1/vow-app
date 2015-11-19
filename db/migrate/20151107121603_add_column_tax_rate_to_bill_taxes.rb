class AddColumnTaxRateToBillTaxes < ActiveRecord::Migration
  def change
    add_column :bill_taxes, :tax_rate, :float
  end
end
