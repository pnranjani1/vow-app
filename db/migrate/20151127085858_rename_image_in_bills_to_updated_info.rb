class RenameImageInBillsToUpdatedInfo < ActiveRecord::Migration
  def change
    rename_column :bills, :image, :updated_info
  end
end
