xml.instruct!
xml.Saledetails do |saledetails|
  if current_authuser.main_roles.first.role_name == "secondary_user"  
    primary_user_id = current_authuser.invited_by_id
    authuser = Authuser.where(:id => primary_user_id).first
    user = authuser.users.first
    xml.version 13.11
            xml.TinNo "#{user.tin_number}"
            xml.RetPerdEnd "#{Date.today.strftime("%Y").to_i}"
            xml.FilingType "M"
            xml.Period"#{Date.today.strftime("%m").to_i}"
  else
     user = current_authuser.users.first
     xml.version 13.11
            xml.TinNo "#{user.tin_number}"
            xml.RetPerdEnd "#{Date.today.strftime("%Y").to_i}"
            xml.FilingType "M"
            xml.Period"#{Date.today.strftime("%m").to_i}"
  end
  
  @user_bills.each do|bill|
    
         
        xml.SaleInvoiceDetails do
            urd_values = ["Other", "Others", "other", "others"] 
           if urd_values.include? bill.customer.name 
            customer = UnregisteredCustomer.where(:bill_id => bill.id).first  
             customer_name = customer.customer_name 
             customer_state = customer.state
             tin = TinNumber.where(:state => customer_state).first 
             tin_number = tin.tin_number 
             xml.PurTin tin_number     
             xml.PurName customer_name      
           else
             xml.PurTin bill.customer.tin_number
             xml.PurName bill.customer.name 
           end
          xml.InvNo bill.invoice_number
          xml.InvDate bill.bill_date.strftime("%Y%m%d")
          xml.NetVal bill.total_bill_price
          if bill.tax_type.present?
          taxes = bill.line_items.pluck(:tax_id)
           tax = taxes.compact.first
           tax_rate = Tax.where(:id => tax).first.tax_rate
           #xml.TaxCh bill.line_items.first.tax.tax_rate
           xml.TaxCh tax_rate
          else
            xml.TaxCh "No Tax"
          end
          service_tax = bill.line_items.pluck(:service_tax_amount).compact
          if (!service_tax.empty?) && (bill.other_charges != nil)
            service_tax_total = bill.line_items.sum(:service_tax_amount)
            xml.OthCh (bill.other_charges + service_tax_total)
          elsif bill.other_charges.present?
            xml.OthCh bill.other_charges 
          else
            xml.OthCh
          end
          xml.TotCh bill.grand_total.round(2)
        end
  end     
end
  

   

