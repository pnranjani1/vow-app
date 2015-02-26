class ChangeDob < ActiveRecord::Migration
  def change
    change_column :authusers, :date_of_birth, :date
  end
end
