class CreateUsercategories < ActiveRecord::Migration
  def change
    create_table :usercategories do |t|
      t.integer :authuser_id
      t.integer :m_categoy_id 
      t.string  :tax_type
      t.float :tax_rate
       

      t.timestamps
    end
  end
end
