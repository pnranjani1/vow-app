class AddColumnBillIdInSugans < ActiveRecord::Migration
  def change
    add_column :sugans, :bill_id, :integer
  end
end
