class AddColumnOtherInformationIdToBills < ActiveRecord::Migration
  def change
    add_column :bills, :other_information_id, :integer
    remove_column :other_informations, :bill_id
  end
end
