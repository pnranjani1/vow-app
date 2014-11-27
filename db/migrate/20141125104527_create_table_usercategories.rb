class CreateTableUsercategories < ActiveRecord::Migration
  def change
    create_table :table_usercategories do |t|
      t.integer :m_category_id
      t.integer :authuser_id
      t.string :tax_type
      t.float :tax_rate
    end
  end
end
