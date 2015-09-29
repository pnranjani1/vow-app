class AddColumnItemDescriptionToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :item_description, :text
  end
end
