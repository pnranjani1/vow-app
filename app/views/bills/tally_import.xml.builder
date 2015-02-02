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
        xml.SVCURRENTCOMPANY current_authuser.name
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
               xml.LEDGERNAME bill.customer.name
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