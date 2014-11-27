class ClientsController < ApplicationController

 before_filter :authenticate_authuser!
  
  
  def index
  end
  
  def new
    @client = Client.new
  end
  
  def create
    @client = Client.new(set_params)
    @client.authuser_id = current_authuser.id
    if @client.save
      redirect_to dashboards_path
    else
      render adtion: 'new'
    end
  end
  
  def show
    @client = Client.find(params[:id])
  end
  
  def edit
    @client = Client.find(params[:id])
  end
  
  def update
    @client = Client.find(params[:id])
    if @client.update_attributes(set_params)
      redirect_to client_path(@client.id)
    else render action: 'edit'
    end
  end
  
  def destroy
    @client = Client.find(params[:id])
    @client.destroy
  end
  
  private
  def set_params
    params[:client].permit(:authuser_id, :remarks, :unique_reference_key)
  end 
    
    
end
