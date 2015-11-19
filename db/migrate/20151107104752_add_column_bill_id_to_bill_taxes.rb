class AddColumnBillIdToBillTaxes < ActiveRecord::Migration
  def change
    add_column :bill_taxes, :bill_id, :integer
  end
end
