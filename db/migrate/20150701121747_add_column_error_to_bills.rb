class AddColumnErrorToBills < ActiveRecord::Migration
  def change
    add_column :bills, :error_message, :string
  end
end
