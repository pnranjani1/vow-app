class CreateOtherInformations < ActiveRecord::Migration
  def change
    create_table :other_informations do |t|
      t.string :other_charges

      t.timestamps
    end
  end
end
