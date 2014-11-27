class CreateAnotherClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :address
      t.string :city
      t.datetime :membership_start_date
      t.datetime :membership_end_date
      t.integer :membership_duration
      t.text :remarks
      t.timestamps
    end
  end
end
