class RenameColumnOtherInformationIdInBills < ActiveRecord::Migration
  def change
    remove_column :bills, :other_information_id
    add_column :bills, :other_charges_information_id, :integer
  end
end
