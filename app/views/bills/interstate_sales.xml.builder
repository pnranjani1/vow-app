xml.instruct!
xml.ISSale do
 
  user = current_authuser.users.first
            xml.TinNo user.tin_number
            xml.RetPerdEnd "#{Date.today.strftime("%Y").to_i}"
            xml.FilinType "M"
            xml.Period "#{Date.today.strftime("%m").to_i}"
         @user_bills.each do |bill|
        xml.ISSaleInv do
             urd_values = ["Other", "Others", "other", "others"] 
             if urd_values.include? bill.customer.name 
              customer = UnregisteredCustomer.where(:bill_id => bill.id).first  
              customer_name = customer.customer_name 
              customer_state = customer.state
              tin = TinNumber.where(:state => customer_state).first 
              number = tin.tin_number 
              xml.PurTin number     
              xml.PurName customer_name  
              xml.PurAddr customer.address        
           else
              xml.PurTin bill.customer.tin_number
              xml.PurName bill.customer.name 
              xml.PurAddr bill.customer.address        
           end
        
        xml.InvNo bill.invoice_number
        xml.InvDate bill.bill_date.strftime("%Y%m%d")
        xml.NetVal bill.total_bill_price
        xml.TaxCh bill.tax.tax_rate
        xml.OthCh bill.other_charges
        xml.TotCh bill.grand_total
        xml.TranType 
        xml.MainComm bill.products.first.usercategory.main_category.commodity_code + "0" 
        xml.SubComm 0
        xml.qty bill.line_items.sum(:quantity)
        end
      end
   end


 
  

   