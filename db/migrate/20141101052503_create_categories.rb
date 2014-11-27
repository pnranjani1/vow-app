class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_name
      t.string :commodity_code
      t.string :sub_commodity_code
      t.integer :user_id
      t.timestamps
    end
  end
end
