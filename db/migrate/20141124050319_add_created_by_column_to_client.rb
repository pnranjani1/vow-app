class AddCreatedByColumnToClient < ActiveRecord::Migration
  def change
    add_column :clients, :created_by, :string
  end
end
