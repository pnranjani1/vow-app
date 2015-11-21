class RemoveColumnFromBillTaxes < ActiveRecord::Migration
  def change
    remove_column :bill_taxes, :tax_type_of_tax
    add_column :taxes, :tax_type_of_tax, :string
  end
end
