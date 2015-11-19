class LineItemsController < ApplicationController
  before_filter :authenticate_authuser!
  
  
  private
  def set_params
    params[:line_item].params(:product_id, :bill_id, :quantity, :unit_price, :total_price, :total_item_price, :item_description,
      {:bill_taxes_attributes => [:id, :line_item_id, :tax_id, :bill_id]}
      )
  end
end
