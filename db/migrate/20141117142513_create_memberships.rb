class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :authuser_id
      t.string :phone_number
      t.datetime :membership_start_date
      t.datetime :membership_end_date
      t.boolean :membership_status
      t.integer :membership_duration

      t.timestamps
    end
  end
end
