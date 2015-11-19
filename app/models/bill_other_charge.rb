class BillOtherCharge < ActiveRecord::Base
  belongs_to :other_charges_information
  belongs_to :bill
end
