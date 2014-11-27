class RemoveColumnsFromCas < ActiveRecord::Migration
  def change
    remove_column :cas, :name
    remove_column :cas, :email
    remove_column :cas, :address
    remove_column :cas, :city
    remove_column :cas, :phone_number
    remove_column :cas, :membership_start_date
    remove_column :cas, :membership_end_date
    remove_column :cas, :membership_duration
    remove_column :cas, :membership_status
  end
end
