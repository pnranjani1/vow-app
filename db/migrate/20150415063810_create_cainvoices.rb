class CreateCainvoices < ActiveRecord::Migration
  def change
    create_table :cainvoices do |t|
      t.integer :authuser_id

      t.timestamps
    end
  end
end
