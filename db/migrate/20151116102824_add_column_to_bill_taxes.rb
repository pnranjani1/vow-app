class AddColumnToBillTaxes < ActiveRecord::Migration
  def change
    add_column :bill_taxes, :tax, :string
  end
end
