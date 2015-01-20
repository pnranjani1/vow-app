class CreateSugans < ActiveRecord::Migration
  def change
    create_table :sugans do |t|
      t.text :number

      t.timestamps
    end
  end
end
