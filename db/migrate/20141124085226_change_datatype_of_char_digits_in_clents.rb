class ChangeDatatypeOfCharDigitsInClents < ActiveRecord::Migration
  def change
    change_column :clients, :digits, :integer
  end
end
