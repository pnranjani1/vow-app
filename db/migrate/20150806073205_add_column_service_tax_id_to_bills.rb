class AddColumnServiceTaxIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :service_tax_id, :integer
  end
end
