class ReferralsController < ApplicationController
 # before_filter :authenticate_authuser!
  
  def index
    @referrals = Referral.all.order('created_at DESC').paginate(:page => params[:per_page], :per_page => 5)
    @count  = @referrals.count
  end
  
  def new
    @referral = Referral.new
  end
  
  def create
    @referral = Referral.new(set_params)
    if @referral.save
      redirect_to referrals_path
      flash[:notice] = "Referral Created Succesfully !"
    else
      render action: 'new'
    end
  end
  
  def show
    @referral = Referral.find(params[:id])
  end
  
  
  def edit
    @referral = Referral.find(params[:id])
  end
  
  def update
    @referral = Referral.find(params[:id])
    if @referral.update_attributes(set_params)
      redirect_to referrals_path
      flash[:notice] = "Referral Updated Succesfully !"
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @referral = Referral.find(params[:id])
    @referral.destroy
    redirect_to referrals_path
  end
  
  def referral_bill
    @referral = Referral.find(params[:id])
     @clients = Client.where(:referral_id => @referral.id)
      @count  = @clients.count
      respond_to do |format|
      format.html
        format.pdf do
      pdf = ReferralBillPdf.new(@referral)
        send_data pdf.render, filename: "#{@referral.name}-bill.pdf", type: "application/pdf", disposition: "inline"
    end
  end
 end
  
  
  def client_acquisition
  end
  
  
  def client_acquisition_report
    start_date = params[:start_date]
    end_date = params[:end_date]
    @start_date = start_date.to_date
    @end_date = end_date.to_date   
    @user = current_authuser
    if  start_date.blank?  && end_date.blank?
      redirect_to referrals_client_acquisition_path, alert: "Please Select the From Date and To Date"
    else
        begin
         respond_to do |format|
          format.html
          format.pdf do
            pdf = ReferralBillPdf.new(@user, @start_date, @end_date)
            send_data pdf.render, filename: "Client Acquisition Report.pdf", type: "application/pdf", disposition: "inline"
          end      
         end
       end
    end
  end
  
  
  
  
  private
  def set_params
    params[:referral].permit(:name, :email, :address_line_1, :address_line_2, :state, :country, :mobile_number)
  end
  
  
  
end
