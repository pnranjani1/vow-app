class RemovingUnwantedTablesAndColumns < ActiveRecord::Migration
  def change
    drop_table :sugans
    drop_table :cainvoices
    remove_column :memberships, :membership_status
    remove_column :referrals, :pricing
    remove_column :clients, :add_role
    remove_column :clients, :admin_id
    remove_column :clients, :approved
    remove_column :bills, :total_price
    remove_column :bills, :service_tax
    remove_column :line_items, :service_tax_rate
    remove_column :line_items, :service_tax_amount
  end
end
