#require 'builder'
class BillsController < ApplicationController
  filter_access_to :all
  before_filter :authenticate_authuser!
  before_filter :generate_invoice_number, only: :new
  require 'will_paginate/array'
  
  #layout 'menu', :only => [:user_bill, :new, :create, :show, :local_sales, :interstate_sales, :tally_import]
   layout_by_action [:user_bill, :new, :create, :show, :local_sales, :interstate_sales, :tally_import, :esnget, :bill_reports, :bill_local_sales_reports, :bill_interstate_sales_reports, :bill_tally_import_reports, :pdf_format, :pdf_format_select, :local_report, :interstate_report, :tally_import_report, :tally_import_excel] => "menu"
  #layout_by_action [:new,:create, :pdf_format, :pdf_format_select] => "menu1"
  
   
   def index
    @bills = Bill.order('created_at DESC')
     @esugam_count = Bill.where("esugam IS NOT NULL").count
    @number_of_cash_applications = Bill.where("esugam IS NULL").count
   end
  
  
  def new
    @bill = Bill.new
    @customer = Customer.new
    @product = Product.new
    @bill.unregistered_customers.build
    @user = current_authuser   
  end
  
  
  def create  
    @bill = Bill.new(set_params)
    @customer = Customer.new
    @product = Product.new
    @user = current_authuser  
    
    if current_authuser.main_roles.first.role_name == "secondary_user"
      invited_by_user_id = current_authuser.invited_by_id
      invited_user = Authuser.find(invited_by_user_id)
      @bill.client_id = invited_user.users.first.client_id
      @bill.authuser_id = current_authuser.id
      @bill.primary_user_id = invited_by_user_id
    else
      @bill.client_id = current_authuser.users.first.client_id
      @bill.authuser_id = current_authuser.id
    end
  
    
    if @bill.save
      @bill.total_bill_price = @bill.line_items.sum(:total_price)
      @bill.save
      flash[:notice] = "Bill Created Successfully"
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
    @bill = Bill.where(id: params["bill_id"]).first
     if @bill.present?
      @bill.get_esugan_number
      # @error = " Oops ! Something went wrong !  " if @bill.esugam.blank?
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
  
        
       # send_data pdf.render, filename: "#{@bill.customer.name} #{@bill.invoice_number}  #{@bill.bill_date.strftime("%b %d %Y")}", type: "application/pdf" ,disposition: "attachment"
      
  
    def edit
    @bill = Bill.find(params[:id])
    end
  
  
  def update
    @bill = Bill.find(params[:id])
    @bill.authuser_id = current_authuser.id
    if @bill.update_attributes(set_params)
      redirect_to bills_user_bill_path
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
       respond_to do |format|
         format.html
         format.xml 
         format.csv { send_data @user_bills.to_csv, :filename => '<bills>.csv' }
         format.xls 
       end
     else
        @user_bills = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')
         respond_to do |format|
           format.html
           format.xml 
           format.csv { send_data @user_bills.to_csv, :filename => '<bills>.csv' }
           format.xls 
         end
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
    @user = Authuser.find(params[:id])
   @client_user = User.where(:client_id => @user.id).paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html
    format.pdf do
    pdf = AdminBillPdf.new(@user)
      send_data pdf.render, filename: "#{@user.name}-bill.pdf", type: "application/pdf", disposition: "inline"
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
        bills1 = Bill.where('authuser_id =? OR primary_user_id =?', primary_user_id, primary_user_id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2
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
        @user_bills = bills1 & bills2
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "VAT")
        @user_bills = bills1 & bills2
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
        @user_bills = bills1 & bills2
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "CST")
        @user_bills = bills1 & bills2
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
        @user_bills = bills1 & bills2
     else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ? AND tax_type = ?', chosen_month.to_time.beginning_of_month, chosen_month.to_time.end_of_month, "CST")
        @user_bills = bills1 & bills2
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
        @user_bills = bills1 & bills2
    else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ?', start_date.to_time, end_date.to_time)
        @user_bills = bills1 & bills2
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
        @user_bills = bills1 & bills2
    else
        bills1 = Bill.where('authuser_id = ? OR primary_user_id = ?', current_authuser.id, current_authuser.id)
        bills2 = Bill.where('created_at >= ? AND created_at <= ?', start_date.to_time, end_date.to_time)
        @user_bills = bills1 & bills2
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

def user_billing_report
  @user = Authuser.find(params[:id])
end

=begin  
  def esnget(bill)
    @bill = bill  
    @tax_type = @bill.tax.tax_type
    @invoice_number = @bill.invoice_number
    @invoice_date = @bill.bill_date
    @customer_tin_number = @bill.customer.tin_number
    @customer_name_address = @bill.customer.name + @bill.customer.city
    @customer_name = @bill.customer.name
   # @bill_product =  @bill.line_items.first.product.product_name
    @product_name =  @bill.line_items.first.product.product_name
    @commodity_name =  @bill.products.first.usercategory.main_category.commodity_name
    @quantity_units = " "+ @bill.line_items.first.quantity.to_s + " " +               @bill.line_items.first.product.units
    @other_value = 0
   
    @total_amount = @bill.total_bill_price
    if @bill.other_charges_info != "" && @bill.other_charges != nil
      @total_amount += @bill.other_charges
    end
    
    tax_amount = @bill.tax.tax_rate * 0.01
    @total_tax = tax_amount * @total_amount
    @total_tax = @total_tax.round(2)
    @grand_total = @total_amount + @total_tax
    @grand_total = @grand_total.round(2)
    
    begin
      browser = Watir::Browser.new :phantomjs

     # browser.goto  "http://vat.kar.nic.in/"
      browser.goto "http://164.100.80.121/vat2/"
      url = nil
      browser.windows.last.use do
        url = browser.url
      end
      
      browser.goto url
      browser.button(:value,"Continue").click rescue nil
      browser.button(:value,"Conitnue").click rescue nil
    browser.text_field(:id, "UserName").set(@bill.authuser.users.first.esugam_username)
    browser.text_field(:id, "Password").set(@bill.authuser.users.first.esugam_password)
      browser.button(:value,"Login").click
      browser.goto "http://164.100.80.121/vat2/web_vat505/Vat505_Etrans.aspx?mode=new"
      browser.goto "http://164.100.80.121/vat2/web_vat505/Vat505_Etrans.aspx?mode=new"
      #browser.button(:value,"Continue").click rescue nil
      #browser.goto "#{url}/CheckInvoiceEnabled.aspx?Form=ESUGAM1"
    if @tax_type == "CST"
        browser.radio(:id, "ctl00_MasterContent_rdoStatCat_1").set
        sleep 5
        browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@customer_tin_number)
        begin
          browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set("BANGALORE")
        rescue => e
          sleep 3
        end
        sleep 5
        begin
          browser.text_field(:id, "ctl00_MasterContent_txtNameAddrs").set(@customer_name)
        rescue => e
          sleep 3
        end
      else
        browser.text_field(:id, "ctl00_MasterContent_txtTIN").set(@customer_tin_number)
        begin
          browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set("BANGALORE")
        rescue => e
          sleep 3
        end
        sleep 3
      end
      sleep 5
    browser.text_field(:id, "ctl00_MasterContent_txtFromAddrs").set(@bill.authuser.address.city)
      browser.text_field(:id, "ctl00_MasterContent_txtToAddrs").set(@bill.customer.city)
      browser.text_field(:id, "ctl00_MasterContent_txt_commodityname").set(@product_name)
      browser.select_list(:id, "ctl00_MasterContent_ddl_commoditycode").select(@commodity_name)
      browser.text_field(:id, "ctl00_MasterContent_txtQuantity").set(@quantity_units)
      browser.send_keys :tab
      browser.text_field(:id, "ctl00_MasterContent_txtNetValue").set(@total_amount)
      browser.send_keys :enter
      browser.send_keys :tab
      browser.text_field(:id, "ctl00_MasterContent_txtVatTaxValue").set(@total_tax)
      browser.text_field(:id, "ctl00_MasterContent_txtOthVal").set(@other_value)
      sleep 3
      browser.text_field(:id, "ctl00_MasterContent_txtInvoiceNO").set(@bill.invoice_number.to_s)

      browser.button(:value,"SAVE AND SUBMIT").click
      page_html = Nokogiri::HTML.parse(browser.html)
      browser.button(:value,"Exit").click
      browser.link(:id, "link_signout").click
      browser.close
                 

      textual = page_html.search('//text()').map(&:text).delete_if{|x| x !~ /\w/}
      esugam = textual.fetch(7)

      if esugam !="e-SUGAM New Entry Form"
        flash.now[:success] = esugam
      else
        esugam = nil
        logger.error "esugam not scraped properly ,mostly"
        flash.now[:error]= "There has been an error in generating the esugam,try again later , if the error does not go away check the esugam username and password , if everything is ok and a number is still not generated , contact the webmaster"
      end
      
      return esugam
    rescue => e
    browser.close if browser
      logger.error " esugam not being generated " + e.to_s
      esugam = nil
      flash.now[:error] = "There has been an error in generating the esugam,try again later , if the error does not go away check the esugam username and password , if everything is ok and a number is still not generated , contact the webmaster" +e.to_s

    end
    end
=end


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
                 @number = updated_number.to_s + " " + primary_user.invoice_string 
               end
             else
               invoice = InvoiceRecord.where(:authuser_id => user.id).last
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
      :authuser_id, :tax, :total_bill_price, :tax_id, :grand_total, :other_charges, :other_charges_information_id,:other_information, :other_charges_info, :client_id, :transporter_name, :vechicle_number, :gc_lr_number,:lr_date, :pdf_format, :service_tax, :primary_user_id, :invoice_number_format, :invoice_format, :record_number, :instant_invoice_format,
      {:line_items_attributes => [:product_id, :quantity, :unit_price, :total_price, :service_tax_rate, :_destroy]},
      {:tax_attributes => [:tax_type, :tax_rate, :tax]},
      {:unregistered_customers_attributes => [:customer_name, :phone_number, :address, :city, :state, :authuser_id, :bill_id]}
     
      )
  end
  end