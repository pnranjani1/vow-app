class AddColumnLrDateToBills < ActiveRecord::Migration
  def change
    add_column :bills, :lr_date, :datetime
  end
end
