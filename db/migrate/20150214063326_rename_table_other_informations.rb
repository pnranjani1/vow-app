class RenameTableOtherInformations < ActiveRecord::Migration
  def change
    rename_table :other_informations, :other_charges_informations
  end
end
