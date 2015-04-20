class AddBillingMonthToCainvoices < ActiveRecord::Migration
  def change
    add_column :cainvoices, :billing_month, :string
  end
end
