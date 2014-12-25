class AddTaxIdColumnToBills < ActiveRecord::Migration
  def change
    add_column :bills, :tax_id, :integer
  end
end
