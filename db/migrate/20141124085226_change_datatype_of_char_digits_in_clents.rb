class ChangeDatatypeOfCharDigitsInClents < ActiveRecord::Migration

=begin
We are not using this digits column anymore, hence commented out.
  def change
    change_column :clients, :digits, 'integer USING CAST(digits AS integer)'
  end
=end
end
