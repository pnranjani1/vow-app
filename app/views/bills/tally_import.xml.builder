xm = Builder::XmlMarkup.new(:target=>$stdout, :indent=>2)
xml.instruct!
 
xml.ENVELOPE do
  xml.HEADER do
  xml.TALLYREQUEST "Import Data"
  end
  xml.BODY do  
    xml.IMPORTDATA do
    xml.REQUESTDESC do    
     xml.REPORTNAME "Vouchers"
    
      xml.STATICVARIABLES do 
        if current_authuser.main_roles.first.role_name == "user"
          xml.SVCURRENTCOMPANY current_authuser.users.first.company
        elsif current_authuser.main_roles.first.role_name == "client"
          xml.SVCURRENTCOMPANY current_authuser.clients.first.company
        end
       #xml.SVCURRENTCOMPANY bill.authuser.name
    
      end
    end
   
     xml.REQUESTDATA do        
      # xml.TALLYMESSAGE do
         xml.TALLYMESSAGE("xmlns:UDF" => "TallyUDF") do
        # xml.VOUCHER do
          # x.sister(“Ani”, “birth” => “January 22″)
         xml.VOUCHER("REMOTEID" => "aaeb8870-afa4-4fe9-bd6f-0f75021f37b5-3RAJ115952",  "VCHTYPE" => "Sales", "ACTION" => "Create") do
        # xml.VOUCHER do "ACTION = Create  VCHTYPE = Sales  REMOTEID = aaeb8870-afa4-4fe9-bd6f-0f75021f37b5-3RAJ115952"
      #     xml.REMOTEID = "aaeb8870-afa4-4fe9-bd6f-0f75021f37b5-3RAJ115952", VCHTYPE="Sales", ACTION="Create"
        
           xml.VOUCHERTYPENAME "Sales"
           @user_bills.each do |bill|
             xml.DATE bill.bill_date.strftime("%Y%m%d")
             xml.EFFECTIVEDATE bill.bill_date.strftime("%Y%m%d")
             xml.REFERENCE bill.invoice_number
             xml.NARRATION do
             end
           xml.GUID "aaeb8870-afa4-4fe9-bd6f-0f75021f37b5-3RAJ115952"
       
             xml.ALLLEDGERENTRIESLIST do
               xml.REMOVEZEROENTRIES "No"
               xml.ISDEEMEDPOSITIVE "Yes"
                urd_values = ["Other", "Others", "other", "others"] 
           if urd_values.include? bill.customer.name 
               customer = UnregisteredCustomer.where(:bill_id => bill.id).first  
               customer_name = customer.customer_name 
               xml.LEDGERNAME customer_name             
           else
               xml.LEDGERNAME bill.customer.name
           end
               xml.AMOUNT -(bill.grand_total)
             end
       xml.ALLLEDGERENTRIESLIST do
               xml.REMOVEZEROENTRIES "No"
               xml.ISDEEMEDPOSITIVE "No"
           xml.LEDGERNAME bill.tax.tax_rate 
           xml.AMOUNT bill.total_bill_price
       end
        xml.ALLLEDGERENTRIESLIST do
               xml.REMOVEZEROENTRIES "No"
               xml.ISDEEMEDPOSITIVE "No"
          xml.LEDGERNAME bill.other_charges_info 
          xml.AMOUNT bill.other_charges
       end
        xml.ALLLEDGERENTRIESLIST do
               xml.REMOVEZEROENTRIES "No"
               xml.ISDEEMEDPOSITIVE "No"
          xml.LEDGERNAME bill.tax.tax
          xml.AMOUNT (bill.tax.tax_rate*0.01).round(2)
       end
            
     end
  end
       end
end
end
end
end