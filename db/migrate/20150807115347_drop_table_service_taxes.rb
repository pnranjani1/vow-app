class DropTableServiceTaxes < ActiveRecord::Migration
  def change
    drop_table :service_taxes
  end
end
