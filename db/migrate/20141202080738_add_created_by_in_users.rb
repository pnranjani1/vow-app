class AddCreatedByInUsers < ActiveRecord::Migration

=begin
  #directly adding this created_by column to users migration 20141030063935_create_users.rb
  def change
    add_column :users, :created_by, :integer
  end
=end
end
