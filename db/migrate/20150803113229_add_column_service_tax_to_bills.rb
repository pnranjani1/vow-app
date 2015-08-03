class AddColumnServiceTaxToBills < ActiveRecord::Migration
  def change
    add_column :bills, :service_tax, :string
  end
end
