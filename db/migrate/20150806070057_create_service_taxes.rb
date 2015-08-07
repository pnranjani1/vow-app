class CreateServiceTaxes < ActiveRecord::Migration
  def change
    create_table :service_taxes do |t|
      t.string :service_tax_name
      t.float :service_tax_rate
      t.timestamps
    end
  end
end
