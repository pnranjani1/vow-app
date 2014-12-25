class AddCommodityNameToUsercategories < ActiveRecord::Migration
  def change
    add_column :usercategories, :commodity_name, :string
  end
end
