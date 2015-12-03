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
           if urd_values.include? bill.customer.company_name 
            customer = UnregisteredCustomer.where(:bill_id => bill.id).first  
             customer_name = customer.customer_name 
             customer_state = customer.state
             tin = TinNumber.where(:state => customer_state).first 
             tin_number = tin.tin_number 
             xml.PurTin tin_number     
             xml.PurName customer_name      
           else
             xml.PurTin bill.customer.tin_number
             xml.PurName bill.customer.company_name 
           end
           xml.InvNo bill.invoice_number
           xml.InvDate bill.bill_date.strftime("%Y%m%d")
          if bill.discount.present?
            xml.NetVal (bill.total_bill_price - bill.discount).round(2)
          else
            xml.NetVal bill.total_bill_price.round(2)
          end
          
           if bill.tax_type != "No Tax"
             tax = bill.bill_taxes.where(:tax_name => "VAT").first.tax_rate
             xml.Taxch tax
           else
             xml.TaxCh 
           end
          
          #if bill.tax_type.present?
          #taxes = bill.line_items.pluck(:tax_id)
          # tax = taxes.compact.first
          # tax_rate = Tax.where(:id => tax).first.tax_rate
          
          #xml.TaxCh bill.line_items.first.tax.tax_rate
          
          #xml.TaxCh tax_rate
          #else
          #  xml.TaxCh "No Tax"
          #end
          
           other_taxes = bill.bill_taxes.where.not(:tax_name => ["VAT", "CST"])          
           other_charges  = bill.other_charges + other_taxes.sum(:tax_amount) 
           other_tax_charges = other_taxes.sum(:tax_amount)
           if bill.other_charges.present?
             xml.OthCh other_charges.round(2)
           else
             xml.OthCh other_tax_charges.round(2)
           end
          #service_tax = bill.line_items.pluck(:service_tax_amount).compact
          #if (!service_tax.empty?) && (bill.other_charges != nil)
          #  service_tax_total = bill.line_items.sum(:service_tax_amount)
#            xml.OthCh (bill.other_charges + service_tax_total)
#          elsif service_tax.present?
#            service_tax_total = bill.line_items.sum(:service_tax_amount)
#            xml.OthCh service_tax_total
#          elsif bill.other_charges.present?
#            xml.OthCh bill.other_charges 
#          else
#            xml.OthCh
          #end
           xml.TotCh bill.grand_total.round(2)
        end
   end     
end
  

   

