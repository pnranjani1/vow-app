class AddColumnDateOfBirthInAuthusers < ActiveRecord::Migration
  def change
    add_column :authusers, :date_of_birth, :datetime
  end
end
