class AddNameOtherChargesIfAnyToBills < ActiveRecord::Migration
  def change
    add_column :bills, :other_charges_info, :string
    rename_column :bills, :remarks, :other_information
  end
end
