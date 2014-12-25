class AddEsugamToBills < ActiveRecord::Migration
  def change
    add_column :bills, :esugam, :string
  end
end
