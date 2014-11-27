class AlterUnitsFromProduct < ActiveRecord::Migration
  def change
    change_column :products, :units, :string
  
  end
end
