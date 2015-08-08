class RenamServiceTaxIdToNameInLineItems < ActiveRecord::Migration
  def change
    rename_column :line_items, :service_tax_id, :service_tax_rate
    change_column :line_items, :service_tax_rate, :float
  end
end
