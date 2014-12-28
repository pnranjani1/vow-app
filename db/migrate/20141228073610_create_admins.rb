class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.integer :authuser_id
      t.timestamps
    end
  end
end
