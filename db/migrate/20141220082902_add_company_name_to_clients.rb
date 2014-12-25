class AddCompanyNameToClients < ActiveRecord::Migration
  def change
    remove_column :clients, :unique_reference_key
    remove_column :clients, :char
    remove_column :clients, :digits
    add_column :clients, :company, :string
  end
end
