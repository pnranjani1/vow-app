class AddColumnTaxIdToBills < ActiveRecord::Migration
  def change
    remove_column :bills, :tax
  end
end
