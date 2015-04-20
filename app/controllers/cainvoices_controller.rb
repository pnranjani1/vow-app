class CainvoicesController < ApplicationController
  before_filter :authenticate_authuser!
  
  def new
    @ca_invoice = Cainvoice.new
  end
  
  def ca_invoice_create
    clients = Client.where(:created_by => current_authuser.id)
    clients.each do |client|
      authuser_id = client.authuser.id
      month = Date.today.strftime("%B")
      if Date.today == Date.today
      Cainvoice.create(:authuser_id => authuser_id, :billing_month => month)
      end
    end
   end
  
    
  private
  
  
  
  def set_params
    params[:ca_invoice].permit(:id, :authuser_id, :billing_month)
  end
  
  
end
