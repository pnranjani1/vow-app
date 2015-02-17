class AddColumnBillIdInOtherInformations < ActiveRecord::Migration
  def change
    add_column :other_informations, :bill_id, :integer
  end
end
