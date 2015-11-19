class RemoveColumnOtherChargesAmountFromInformations < ActiveRecord::Migration
  def change
    remove_column :other_charges_informations, :other_charges_amount
    add_column :bill_other_charges, :other_charges_amount, :float
  end
end
