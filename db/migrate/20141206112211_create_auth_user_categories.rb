class CreateAuthUserCategories < ActiveRecord::Migration
  def change
    create_table :auth_user_categories do |t|
      t.integer :authuser_id

      t.timestamps
    end
  end
end
