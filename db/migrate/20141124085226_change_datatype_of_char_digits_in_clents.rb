class ChangeDatatypeOfCharDigitsInClents < ActiveRecord::Migration
  def change
    change_column :clients, :digits, 'integer USING CAST(digits AS integer)'
  end
end
