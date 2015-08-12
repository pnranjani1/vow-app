class InvoiceRecord < ActiveRecord::Base

  
 
  belongs_to :bill
  belongs_to :authuser

  
  

end
