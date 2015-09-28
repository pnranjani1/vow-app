class AddColumnTaxRateInLineItems < ActiveRecord::Migration
  def change
    
    add_column :line_items, :tax_rate, :float
    add_column :line_items, :tax_id, :integer
  end
end
