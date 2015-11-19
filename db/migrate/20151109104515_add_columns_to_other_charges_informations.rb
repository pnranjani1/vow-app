class AddColumnsToOtherChargesInformations < ActiveRecord::Migration
  def change
    add_column :other_charges_informations, :other_charges_amount, :float
    remove_column :bills, :other_charges_info
    remove_column :bills, :other_charges_information_id
  end
end
