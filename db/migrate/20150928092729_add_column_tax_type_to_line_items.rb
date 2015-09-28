class AddColumnTaxTypeToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :tax_type, :string
  end
end
