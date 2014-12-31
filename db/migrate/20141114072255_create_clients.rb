class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.integer :tin_number
      t.string :phone_number
      t.datetime :membership_start_date
      t.datetime :membership_end_date
      t.integer :membership_duration
      t.boolean :membership_status
      t.string :created_by #manually added this.

      t.timestamps
    end
  end
end
