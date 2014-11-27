class AddColumnsToCas < ActiveRecord::Migration
  def change
    add_column :cas, :unique_reference_key, :string
    add_column :cas, :remarks, :string
  end
end
