class AddColumnsToUsercategories < ActiveRecord::Migration
  def change
    add_column :usercategories, :authuser_id, :integer
    add_column :usercategories, :m_category_id, :integer
    add_column :usercategories, :tax_type, :string
    add_column :usercategories, :tax_rate, :float
  end
end
