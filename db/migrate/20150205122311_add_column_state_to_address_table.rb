class AddColumnStateToAddressTable < ActiveRecord::Migration
  def change
    add_column :addresses, :state, :string
  end
end
