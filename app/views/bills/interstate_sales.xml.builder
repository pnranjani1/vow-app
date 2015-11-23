xml.instruct!
xml.ISSale do
  if current_authuser.main_roles.first.role_name == "secondary_user"  
    primary_user_id = current_authuser.invited_by_id
    authuser = Authuser.where(:id => primary_user_id).first
    user = authuser.users.first
            xml.TinNo "#{user.tin_number}"
            xml.RetPerdEnd "#{Date.today.strftime("%Y").to_i}"
            xml.FilinType "M"
            xml.Period "#{Date.today.strftime("%m").to_i}"
  else
     user = current_authuser.users.first
            xml.TinNo "#{user.tin_number}"
            xml.RetPerdEnd "#{Date.today.strftime("%Y").to_i}"
            xml.FilinType "M"
            xml.Period "#{Date.today.strftime("%m").to_i}"
  end
       @user_bills.each do |bill|
        xml.ISSaleInv do
             urd_values = ["Other", "Others", "other", "others"] 
             if urd_values.include? bill.customer.company_name 
              customer = UnregisteredCustomer.where(:bill_id => bill.id).first  
              customer_name = customer.customer_name 
              customer_state = customer.state
              tin = TinNumber.where(:state => customer_state).first 
              number = tin.tin_number 
              xml.PurTin number     
              xml.PurName customer_name  
              xml.PurAddr customer.city        
           else
              xml.PurTin bill.customer.tin_number
              xml.PurName bill.customer.company_name 
              xml.PurAddr bill.customer.city        
           end
        
           xml.InvNo bill.invoice_number
           xml.InvDate bill.bill_date.strftime("%Y%m%d")
           if bill.discount.present?
             xml.NetVal bill.total_bill_price - bill.discount
           else
             xml.NetVal bill.total_bill_price
           end
          
           if bill.tax_type != "No Tax"
             tax = bill.bill_taxes.where(:tax_name => "CST").first.tax_rate
             xml.Taxch tax
           else
             xml.TaxCh 
           end
         
        #if bill.tax_type.present?
#           taxes = bill.line_items.pluck(:tax_id)
#           tax = taxes.compact.first
#           tax_rate = Tax.where(:id => tax).first.tax_rate
#           xml.TaxCh tax_rate
#        else
#           xml.TaxCh "No Tax"
#        end
           other_taxes = bill.bill_taxes.where.not(:tax_name => ["VAT", "CST"])
           other_charges  = bill.other_charges + other_taxes.sum(:tax_amount) 
           other_tax_charges = other_taxes.sum(:tax_amount)
           if bill.other_charges.present?
             xml.OthCh other_charges
           else
            xml.OthCh other_tax_charges
           end
           xml.TotCh bill.grand_total
           xml.TranType 
           xml.MainComm bill.products.first.usercategory.main_category.commodity_code + "0" 
           xml.SubComm 0
           xml.qty bill.line_items.sum(:quantity)
        end
      end
   end


 
  

   