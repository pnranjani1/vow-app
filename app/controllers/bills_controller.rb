class BillsController < ApplicationController
  def index
    @bills = Bill.all
  end
  
  def new
    @bill = Bill.new
  end
  
  def show
    @bill = Bill.find(params[:id])
  end
  
end
