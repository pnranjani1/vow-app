class AddUniqueKeyColumnsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :char, :string
    add_column :clients, :digits, :string
  
  end
end
