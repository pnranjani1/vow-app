class CreateJoinTableProductsBills < ActiveRecord::Migration
  def change
    create_table :products_bills do |t|
      t.integer :bill_id
      t.integer :product_id
      
      t.timestamps
    end
    
  end
end
