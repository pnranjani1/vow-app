class Bankdetail < ActiveRecord::Base
  belongs_to :authuser
  
  validates :bank_account_number, :ifsc_code, presence: true
  validates :bank_account_number, length: { in: 6..15}
  
end
