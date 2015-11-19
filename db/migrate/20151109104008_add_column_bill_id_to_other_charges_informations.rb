class AddColumnBillIdToOtherChargesInformations < ActiveRecord::Migration
  def change
    add_column :other_charges_informations, :bill_id, :integer
  end
end
