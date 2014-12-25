class AddOtherChargesToBills < ActiveRecord::Migration
  def change
    add_column :bills, :other_charges, :float
  end
end
