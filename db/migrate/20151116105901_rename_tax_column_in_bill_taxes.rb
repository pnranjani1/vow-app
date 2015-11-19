class RenameTaxColumnInBillTaxes < ActiveRecord::Migration
  def change
    rename_column :bill_taxes, :tax, :tax_type
  end
end
