class AddTaxTypeToBills < ActiveRecord::Migration
  def change
    add_column :bills, :tax_type, :string
  end
end
