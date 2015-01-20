class CreateEnquiryForms < ActiveRecord::Migration
  def change
    create_table :enquiry_forms do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :comments
      
      
      t.timestamps
    end
  end
end
