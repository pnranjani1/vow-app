class CreateTinNumbers < ActiveRecord::Migration
  def change
    create_table :tin_numbers do |t|
      t.string :state
      t.string :tin_number
      t.timestamps
    end
  end
end
