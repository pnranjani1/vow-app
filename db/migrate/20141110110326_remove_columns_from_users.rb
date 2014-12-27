class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :tin_number, :string
    remove_column :users, :phone_number, :string
    remove_column :users , :address, :string
    remove_column :users, :city, :string
    remove_column :users, :bank_account_number, :integer
    remove_column :users, :ifsc_code, :string
    remove_column :users, :membership_start_date, :datetime
    remove_column :users, :membership_end_date, :datetime
    remove_column :users, :membership_duration, :integer
    
  end
end
