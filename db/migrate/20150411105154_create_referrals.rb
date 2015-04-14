class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :state
      t.string :country
      t.string :mobile_number
      t.timestamps
    end
  end
end
