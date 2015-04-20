class Cainvoice < ActiveRecord::Base
  
  belongs_to :authuser
  before_save :update_cainvoice
  
  
  def update_cainvoice
    if Date.today == Date.today
      clients = Client.where(:created_by => 1 )
      clients.each do |client|
        authuser_id = client.authuser.id
        month = Date.today.strftime("%B")
        Cainvoice.create(:authuser_id => authuser.id , :billing_month => month)
      end
  end
end

  
end