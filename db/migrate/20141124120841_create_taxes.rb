class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :tax_type
      t.float :tax_rate
      t.integer :usercategory_id

      t.timestamps
    end
  end
end
