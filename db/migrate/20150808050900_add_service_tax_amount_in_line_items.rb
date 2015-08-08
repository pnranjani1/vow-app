class AddServiceTaxAmountInLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :service_tax_amount, :float
  end
end
