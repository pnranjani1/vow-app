#require 'builder'
class BillsController < ApplicationController
  
  filter_access_to :all
  before_filter :authenticate_authuser!
  before_filter :generate_invoice_number, only: :new
  require 'will_paginate/array'
  
  #layout 'menu', :only => [:user_bill, :new, :create, :show, :local_sales, :interstate_sales, :tally_import]
   layout_by_action [:user_bill, :new, :create, :show, :local_sales, :interstate_sales, :tally_import, :esnget, :bill_reports, :bill_local_sales_reports, :bill_interstate_sales_reports, :bill_tally_import_reports, :pdf_format, :pdf_format_select, :local_report, :interstate_report, :tally_import_report, :tally_import_excel, :edit, :bill_edit] => "menu"
  #layout_by_action [:new,:create, :pdf_format, :pdf_format_select] => "menu1"
  
   
   def index
    @bills = Bill.order('created_at DESC')
    @esugam_count = Bill.where("esugam IS NOT NULL").count
    @number_of_cash_applications = Bill.where("esugam IS NULL").count
   end
  
  
  def new
    @taxes = Tax.all
    @bill = Bill.new
    #@bill = current_authuser.bills.last
    @customer = Customer.new
    @product = Product.new
    @bill.unregistered_customers.build
    @user = current_authuser   
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
       @user_customers = Customer.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
       @user_products = Product.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
      else
       @user_customers = Customer.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
       #@user_products = Product.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
       @user_products = Product.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
      end
   end
  
  
  def create  
    @bill = Bill.new(set_params)
    @taxes = Tax.all
    @customer = Customer.new
    @product = Product.new
    @user = current_authuser  
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
       @user_customers = Customer.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
       @user_products = Product.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
      else
       @user_customers = Customer.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
       @user_products = Product.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
      end
    
    if current_authuser.main_roles.first.role_name == "secondary_user"
      invited_by_user_id = current_authuser.invited_by_id
      invited_user = Authuser.find(invited_by_user_id)
      @bill.client_id = invited_user.users.first.client_id
      @bill.authuser_id = current_authuser.id
      @bill.primary_user_id = invited_by_user_id
    elsif current_authuser.main_roles.first.role_name == "user"
      @bill.client_id = current_authuser.users.first.client_id
      @bill.primary_user_id = current_authuser.id
      @bill.authuser_id = current_authuser.id
    elsif current_authuser.main_roles.first.role_name == "client"
      @bill.client_id = current_authuser.id
      @bill.primary_user_id = current_authuser.id
      @bill.authuser_id = current_authuser.id
    end
    customer_id = params[:bill]['customer_id']
    customer = Customer.where(:id => customer_id).first
   # if customer.name != "Others"
    urd_values = ["others", "other", "Others", "Other"]
    if !urd_values.include? customer.name 
      @bill.unregistered_customers.first.delete
      #urd = UnregisteredCustomer.where(:bill_id => @bill.id).first
      #urd.delete
    #else
      #@bill.unregistered_customers.first.save
      #@bill.unregistered_customers.bill_id = @bill.id
     # urd = UnregisteredCustomer.where(:bill_id => @bill.id).first.save
    end
    if @bill.save
       @bill.update_attribute(:total_bill_price, @bill.line_items.sum(:total_price))
       redirect_to bill_path(@bill.id)
    else
       render action: 'new'
    end
    end
       
  def get_tin
    #state = params[:unregistered_customer][:state]
    @tin_number = TinNumber.where(:state => params[:state]).first.tin_number
  end
  
  
  def generate_esugan
  #  raise params.inspect
    @bill = Bill.where(id: params["bill_id"]).first
     if @bill.present?
       @bill.get_esugam_number  
       #bill.update_attribute(:esugam, rand(1..200))
      
     end
  end
 
  
  def show
    @bill = Bill.find(params[:id])    
    respond_to do |format|
      format.html  do
      end
      format.pdf do
       if @bill.pdf_format ==  "Format1" 
           pdf = BillPdf.new(@bill)
           send_data pdf.render, filename: "#{@bill.customer.name}  #{@bill.invoice_number}  #{@bill.bill_date.strftime("%b %d %Y")}.pdf", type: "application/pdf" , disposition: "inline"
       elsif @bill.pdf_format == "Format2"
           pdf = BillPdfTwo.new(@bill)
           send_data pdf.render, filename: "#{@bill.customer.name}  #{@bill.invoice_number}  #{@bill.bill_date.strftime("%b %d %Y")}.pdf", type: "application/pdf" , disposition: "inline"
       elsif @bill.pdf_format == "Format3"
           pdf = BillPdfThree.new(@bill)
           send_data pdf.render, filename: "#{@bill.customer.name}  #{@bill.invoice_number}  #{@bill.bill_date.strftime("%b %d %Y")}.pdf", type: "application/pdf" , disposition: "inline"
     elsif @bill.pdf_format == "Format4"
      pdf = BillPdfFour.new(@bill)
           send_data pdf.render, filename: "#{@bill.customer.name}  #{@bill.invoice_number}  #{@bill.bill_date.strftime("%b %d %Y")}.pdf", type: "application/pdf" , disposition: "inline"
       elsif @bill.pdf_format == nil
           pdf = BillPdf.new(@bill)
           send_data pdf.render, filename: "#{@bill.customer.name}  #{@bill.invoice_number}  #{@bill.bill_date.strftime("%b %d %Y")}.pdf", type: "application/pdf" , disposition: "inline"
       end
      end
    end      
  end
  
  def edit
    @bill = Bill.find(params[:id])
    @user = current_authuser
    @taxes = Tax.all
    @customer = Customer.new
    @product = Product.new
    @bill.unregistered_customers.build
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
       @user_customers = Customer.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
       @user_products = Product.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
      else
       @user_customers = Customer.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
       @user_products = Product.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
      end      
    end
  
    def update
      @bill = Bill.find(params[:id])    
      @user = current_authuser  
      @taxes = Tax.all
      @customer = Customer.new
      @product = Product.new
      @bill.unregistered_customers.build
    
      if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        @user_customers = Customer.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
        @user_products = Product.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
      else
        @user_customers = Customer.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        @user_products = Product.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
      end
    
      if current_authuser.main_roles.first.role_name == "secondary_user"
        invited_by_user_id = current_authuser.invited_by_id
        invited_user = Authuser.find(invited_by_user_id)
        @bill.client_id = invited_user.users.first.client_id
        @bill.authuser_id = current_authuser.id
        @bill.primary_user_id = invited_by_user_id
      elsif current_authuser.main_roles.first.role_name == "user"
        @bill.client_id = current_authuser.users.first.client_id
        @bill.primary_user_id = current_authuser.id
        @bill.authuser_id = current_authuser.id
      elsif current_authuser.main_roles.first.role_name == "client"
        @bill.client_id = current_authuser.id
        @bill.primary_user_id = current_authuser.id
        @bill.authuser_id = current_authuser.id
      end
     # customer_id = @bill.customer_id
      customer_id = params[:bill]['customer_id']
      customer = Customer.where(:id => customer_id).first   
      
     # if customer.name != "Others"
      urd_values = ["others", "other", "Others", "Other"]
      if !urd_values.include? customer.name 
        @bill.unregistered_customers.first.delete
      end
     
     # @bill.authuser_id = current_authuser.id
      if @bill.update_attributes(set_params)
         @bill.update_attribute(:total_bill_price, @bill.line_items.sum(:total_price))
         redirect_to bill_path(@bill.id)
      else
        render action: 'edit'
      end
    end
  
  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy
    redirect_to bills_user_bill_
  end
  
  
  def user_bill
    #shows all the bills of primary user and secondary users of that primary user
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        @user_bills = Bill.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
       user_bills = Bill.where('authuser_id =? OR primary_user_id =? ', primary_user_id, primary_user_id)
       respond_to do |format|
         format.html
         format.xml 
         format.csv { send_data user_bills.to_csv, :filename => '<bills>.csv' }
         format.xls 
       end
     else
        @secondary_users = Authuser.where(:invited_by_id => current_authuser.id)
        @user_bills = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
        user_bills = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
         respond_to do |format|
           format.html
           format.xml 
           format.csv { send_data user_bills.to_csv, :filename => '<bills>.csv' }
           format.xls 
         end
     end
  end

  def download_excel
    if current_authuser.main_roles.first.role_name == "secondary_user"
      @user_bills = Bill.where(:primary_user_id => [current_authuser.id, current_authuser.invited_by.id])
    else
      @user_bills = Bill.where(:primary_user_id => current_authuser.id)
    end
  end
     
   def bill_local_sales_reports
   end
  
  def bill_interstate_sales_reports
  end
  
  def bill_tally_import_reports
  end
  
 
  
  def user_bill_summary
    @client_user = User.where(:client_id => current_authuser.id).paginate(:page => params[:page], :per_page => 5)
    @clients = Client.where(:created_by => current_authuser.id)
    @clients.each do |client|
    client_id = client.authuser.id
   @users = User.where(:client_id => 7)
    #@clients = Client.where(:created_by => current_authuser.id)
    #@clients.each do |client|
     # client_id = client.authuser.id
      #@user = Authuser.find(client_id)
    # @user = User.where(:client_id => client_id).first
    end
        
  end
  
  def client_bill_summary
    @clients = Client.where(:created_by => current_authuser.id).paginate(:page => params[:page], :per_page => 5)
    @clients.each do |client|
    client_id = client.authuser.id
    #bills = Bill.where(:client_id => client_id)
     # @bills_esugam = bills.where('ESUGAM IS NOT NULL').count
      #@bills_cash_based_applications = bills.where('ESUGAM IS NULL').count
      users = User.where(:client_id => client_id)
      users.each do |user|
      @users_bills = user.authuser.bills.count
      end 
    end
  end

  def client_pdf_bill
    @client = Authuser.find(params[:id])
  end
  

  def client_billing_report
  end

def client_monthly_bill
   chosen_month = params[:choose_month]
  @clients = Client.where(:created_by => current_authuser.id)
 @user_bills = Bill.where('created_at >= ? AND created_at <= ? ',chosen_month.to_date.beginning_of_month, chosen_month.to_date.end_of_month)
    respond_to do |format|
     format.html
     format.xls 
end
end
  
  
  def bill_details_client 
    @client = Authuser.find(params[:id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    #@client_user = User.where(:client_id => @client.id).paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html
    format.pdf do
      pdf = AdminBillPdf.new(@client, @start_date, @end_date)
      send_data pdf.render, filename: "#{@client.name}-bill.pdf", type: "application/pdf", disposition: "inline"
      end
    end
   end
 
  
  # def local_sales
  #month = params['Month'][0..1]
  # xml = LocalSales.new(current_authuser.id,month).generate_xml
  #send_data xml,
   #        :filename =>  "Local_sales_"+Date.today.strftime("%m")+".xml",
    #          :type => "text/xml; charset=UTF-8",
     #        :disposition => "attachment"
    #end

  #def interstate_sales
  # month = params['Month'][0..1]
   # xml = InterStateSales.new(current_authuser.id,month).generate_xml
    #send_data xml,
     #         :filename =>  "Interstate_sales_"+Date.today.strftime("%m")+".xml",
      #        :type => "text/xml; charset=UTF-8",
       #       :disposition => "attachment"
  #end

  
  def local_sales
    #tax = Bill.where(:tax_id => (Tax.where(:tax_type => "VAT")))
      chosen_month = params[:choose_month]
    #user_bills = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ? AND authuser_id = ? ',chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT", current_authuser.id)
    #secondary_user_bills = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ? AND primary_user_id = ? ',chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT", current_authuser.id)
    #@user_bills = user_bills + secondary_user_bills
    
      if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
       # bills1 is to get the user total bills
       # bills2 is to get the bills of that user for a particular month and tax type
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2.order('created_at ASC')
      else 
        # bills1 is to get the user total bills
        # bills2 is to get the bills of that user for a particular month and tax type
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2.order('created_at ASC')
       end
       respond_to do |format|
         format.html
         format.xml {  send_data render_to_string(:local_sales), :filename => 'local_sales.xml', :type=>"application/xml", :disposition => 'attachment' }
end
  end
      

  def local_report
  end

  def local
      chosen_month = params[:choose_month]
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2.order('created_at ASC')
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2.order('created_at ASC')
       end
       respond_to do |format|
        format.html
         format.xls
       end
  end


  def interstate_sales       
     chosen_month = params[:choose_month]
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "CST")
        @user_bills = bills1 & bills2.order('created_at ASC')
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "CST")
        @user_bills = bills1 & bills2.order('created_at ASC')
     end
     respond_to do |format|
        format.html
        format.xml {  send_data render_to_string(:interstate_sales), :filename => 'interstate_sales.xml', :type=>"application/xml", :disposition => 'attachment' }
     end
  end

  def interstate_report
  end

  def interstate
     chosen_month = params[:choose_month]
     if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "CST")
        @user_bills = bills1 & bills2.order('created_at ASC')
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "CST")
        @user_bills = bills1 & bills2.order('created_at ASC')
     end
     respond_to do |format|
        format.html
        format.xls
     end
  end
 
    
  def tally_import
    start_date = params[:start_date]
    end_date = params[:end_date]
    if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ?', start_date.to_time, end_date.to_time)
        @user_bills = bills1 & bills2.order('created_at ASC')
    else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ?', start_date.to_time, end_date.to_time)
        @user_bills = bills1 & bills2.order('created_at ASC')
    end
    #@user_bills = Bill.where('created_at >= ? AND created_at <= ? AND authuser_id = ? OR primary_user_id = ?',start_date.to_time, end_date.to_time, current_authuser.id, current_authuser.id )
    respond_to do|format|
     format.html
     format.xml {  send_data render_to_string(:tally_import), :filename => 'tally_import.xml', :type=>"application/xml", :disposition => 'attachment' }
    end
  end

  def tally_import_report
  end

  def tally_import_excel
     start_date = params[:start_date]
     end_date = params[:end_date]
    if current_authuser.main_roles.first.role_name == "secondary_user"
        primary_user_id = current_authuser.invited_by_id
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ?', start_date.to_time, end_date.to_time)
        @user_bills = bills1 & bills2.order('created_at ASC')
    else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ?', start_date.to_time, end_date.to_time)
        @user_bills = bills1 & bills2.order('created_at ASC')
    end
      respond_to do |format|
        format.html
        format.xls
      end
  end
 
  def user_billing
    chosen_month = params[:choose_month]
    @client_user = User.where(:client_id => current_authuser.id)
    @user_bills = Bill.where('created_at >= ? AND created_at <= ? ',chosen_month.to_date.beginning_of_month, chosen_month.to_date.end_of_month)
    respond_to do |format|
      format.html
      format.xls 
    end
  end

  def user_pdf
    @user = Authuser.find(params[:id])
  end

  def user_billing_report
    @user = Authuser.find(params[:id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    @start_date = start_date.to_date
    @end_date = end_date.to_date
    respond_to do |format|
      format.html
      format.pdf do
        pdf = BillForUserPdf.new(@user, @start_date, @end_date)
        send_data pdf.render, filename: "#{@user.name}-bill.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end


  def pdf_format
    @bill = Bill.find(params[:id])
  end

  def pdf_format_select
    @bill = Bill.find(params[:id])  
    #@bill.pdf_format = params[:bill][:pdf_format]
   # if params[:bill][:pdf_format].blank?
    #  redirect_to bill_path(@bill.id)
     # flash[:alert] = "No Format Selected"
    #end
    if @bill.update_attribute('pdf_format', params[:bill][:pdf_format])
     redirect_to bill_path(@bill.id)
    else   
      redirect_to bill_path(@bill.id)
      flash[:alert] = "Select a PDF format"
    end
  end


  def secondary_user_bill
  end


  def secondary_user_activity_report
    chosen_month = params[:choose_month]
    user = current_authuser
    secondary_users = Authuser.where(:invited_by_id => user.id)
    
    @bills = Bill.where()
    respond_to do |format|
      format.html
      respond.xls
    end
  end

   def get_tin
     state = params[:bill][:unregistered_customer][:state]
     tin = TinNumber.where(:state => state)
   end

   def captcha
     @bill = Bill.find(params[:id])
   end

  def captcha_image
    @bill = Bill.find(params[:id])
    if @bill.update_attribute(:image, params[:bill][:image])
      redirect_to bill_path(@bill.id)
    else
      render action: 'new'
    end
  end

  private

  def generate_invoice_number
  # logic to generate automated invoice number 
    if current_authuser.invoice_format == 'automatic'
     
       if current_authuser.main_roles.first.role_name != "secondary_user" 
         user = current_authuser 
         if user.invoice_format == "automatic"
           #instant automated/ manual process
          if user.invoice_records.empty? 
            if user.invoice_string.nil? || user.invoice_string.blank? 
              @number = "000001" 
            else 
              @number = "01" + " " + user.invoice_string 
            end
          else #when invoice record is not empty
            #bill_id = Bill.where(:authuser_id => user.id).last.id 
            
            if user.invoice_string.nil? || user.invoice_string.blank?
              invoice = InvoiceRecord.where(:authuser_id => user.id).last
              number_updated = invoice.number.to_i + 1
              if number_updated.to_s.length < 6 
                updated_number = number_updated.to_s.rjust(6, '0')
                @number = updated_number.to_s 
              end
            else 
              invoice = InvoiceRecord.where(:authuser_id => user.id).last
              number_updated = invoice.number.to_i + 1
              @number = number_updated.to_s + " " + user.invoice_string
            end
          end #user invoice record ends
         end # primary user automatic mode ends here -
    else # secondary user automatic mode starts here
        primary_user_id = current_authuser.invited_by_id
        secondary_user = current_authuser
        primary_user = Authuser.where(:id => primary_user_id).first 
        if secondary_user.invoice_format == "automatic"
           if primary_user.invoice_records.empty?
             if primary_user.invoice_string.nil? || primary_user.invoice_string.blank?
                 @number = "000001" 
             else
                 @number = "01" + " " + primary_user.invoice_string 
             end 
           else# primary user has invoice records 
             
             if primary_user.invoice_string.nil? || primary_user.invoice_string.blank?
               invoice = InvoiceRecord.where(:authuser_id => primary_user.id).last
               number_updated = invoice.number.to_i + 1
               if number_updated.to_s.length < 6 
                 updated_number = number_updated.to_s.rjust(6, '0')
                 @number = updated_number.to_s 
               end
             else
               invoice = InvoiceRecord.where(:authuser_id => primary_user.id).last
               number_updated = invoice.number.to_i + 1
               @number = number_updated.to_s + " " + primary_user.invoice_string
             end
           end # primary user invoice record ends
        end
    end
   @number
   end
 end


   def set_params
     params[:bill].permit(:invoice_number, :esugam, :bill_date, :customer_id, 
      :authuser_id, :tax, :total_bill_price, :tax_id, :grand_total, :other_charges, :other_charges_information_id,:other_information, :other_charges_info, :client_id, :transporter_name, :vechicle_number, :gc_lr_number,:lr_date, :pdf_format, :service_tax, :primary_user_id, :invoice_number_format, :invoice_format, :record_number, :instant_invoice_format, :image, :discount, 
      {:line_items_attributes => [:product_id, :quantity, :unit_price, :total_price, :service_tax_rate, :tax_rate, :tax_id, :item_description,  :_destroy]},
      {:tax_attributes => [:tax_type, :tax_rate, :tax]},
       {:unregistered_customers_attributes => [:id, :customer_name, :phone_number, :address, :city, :state, :authuser_id, :bill_id]}
     
      )
  end
  end