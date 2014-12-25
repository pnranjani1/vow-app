class AddTaxColumnToTaxes < ActiveRecord::Migration
  def change
    add_column :taxes, :tax, :string
  end
end
