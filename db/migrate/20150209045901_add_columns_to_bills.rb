class AddColumnsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :transporter_name, :string
    add_column :bills, :vechicle_number, :string
    add_column :bills, :gc_lr_number, :string
  end
end
