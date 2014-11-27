class DropTablesTaxBills < ActiveRecord::Migration
  def change
    drop_table :taxes
    drop_table :bills
  end
end
