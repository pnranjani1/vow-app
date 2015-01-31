class RemoveColumnDateOfBirthAuthusers < ActiveRecord::Migration
  def change
    remove_column :authusers, :date_of_birth
  end
end
