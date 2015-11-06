class RenameColumnsInTaxes < ActiveRecord::Migration
  def change
    add_column :taxes, :authuser_id, :integer
    remove_column :taxes, :tax_type
    remove_column :taxes, :tax_rate
    remove_column :taxes, :tax
    add_column :taxes, :tax_name, :string
    add_column :taxes, :tax_type, :string
    add_column :taxes, :tax_on_tax, :boolean
  end
end
