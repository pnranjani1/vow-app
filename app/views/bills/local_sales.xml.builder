xml.instruct!
xml.Saledetails do |saledetails|
    
  user = current_authuser.users.first
        xml.version 13.11
            xml.TinNo user.tin_number
            xml.RetPerdEnd "#{Date.today.strftime("%Y").to_i}"
            xml.FilingType "M"
            xml.Period"#{Date.today.strftime("%m").to_i}"
      
  @user_bills.each do|bill|
     
        xml.SaleInvoiceDetails do
        xml.PurTin bill.customer.tin_number
        xml.PurName bill.customer.name 
        xml.InvNo bill.invoice_number
          xml.InvDate bill.bill_date.strftime("%Y%m%d")
        xml.NetVal bill.total_bill_price
        xml.TaxCh bill.tax.tax_rate
        xml.OthCh bill.other_charges
        xml.TotCh bill.grand_total
        end
  end     
end
  

   

