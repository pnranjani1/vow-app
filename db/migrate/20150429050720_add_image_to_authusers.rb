class AddImageToAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :image, :string
  end
end
