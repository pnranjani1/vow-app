class AddColumnImageToBills < ActiveRecord::Migration
  def change
    add_column :bills, :image, :string
  end
end
