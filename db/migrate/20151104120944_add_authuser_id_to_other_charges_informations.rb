class AddAuthuserIdToOtherChargesInformations < ActiveRecord::Migration
  def change
    add_column :other_charges_informations, :authuser_id, :integer
  end
end
