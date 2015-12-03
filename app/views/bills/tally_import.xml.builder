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
     end # request desc ends
   
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
                  if urd_values.include? bill.customer.company_name 
                    customer = UnregisteredCustomer.where(:bill_id => bill.id).first  
                    customer_name = customer.customer_name 
                    xml.LEDGERNAME customer_name             
                  else
                    xml.LEDGERNAME bill.customer.company_name
                  end
                  xml.AMOUNT -(bill.grand_total).round(2)
                end #alleged entry lis ends
               
                xml.ALLLEDGERENTRIESLIST do
                  xml.REMOVEZEROENTRIES "No"
                  xml.ISDEEMEDPOSITIVE "No"
                  
                   if bill.tax_type != "No Tax"
                     tax = bill.bill_taxes.where(:tax_name => ["VAT", "CST"]).first.tax_rate
                     xml.LEDGERNAME tax
                   else
                     xml.LEDGERNAME
                   end
                  
#if bill.tax_type != 'No Tax'
# taxes = bill.line_items.pluck(:tax_id)
#tax = taxes.compact.first
#taxrate = Tax.where(:id => tax).first.tax_rate
#xml.LEDGERNAME taxrate
#else
# xml.LEDGERNAME 
#end
                  if bill.discount.present?                 
                    xml.AMOUNT (bill.total_bill_price - bill.discount).round(2)
                  else
                    xml.AMOUNT bill.total_bill_price.round(2)
                  end
                end #alleged entry list ends
               
                xml.ALLLEDGERENTRIESLIST do
                   xml.REMOVEZEROENTRIES "No"
                   xml.ISDEEMEDPOSITIVE "No"
                   other_taxes = bill.bill_taxes.where.not(:tax_name => ["VAT", "CST"])          
                   other_charges  = bill.other_charges + other_taxes.sum(:tax_amount) 
                   other_tax_charges = other_taxes.sum(:tax_amount)
                   if bill.other_charges.present?
                     xml.AMOUNT other_charges.round(2)
                   else
                     xml.AMOUNT other_tax_charges.round(2)
                    end
                  
                   #service_tax = bill.line_items.pluck(:service_tax_amount).compact
                   #if (!service_tax.empty?) && (bill.other_charges != nil)
#                     xml.LEDGERNAME bill.other_charges_information.other_charges 
                     #service_tax = bill.line_items.sum(:service_tax_amount)
                     #xml.AMOUNT (bill.other_charges + service_tax)
                   #elsif service_tax.present? 
                    # service_amount = bill.line_items.sum(:service_tax_amount)
                    # xml.AMOUNT service_amount
                   #elsif bill.other_charges.present?
                   #  xml.LEDGERNAME bill.other_charges_information.other_charges 
                   #  xml.AMOUNT bill.other_charges 
                   #else
                   #  xml.LEDGERNAME  
                   #  xml.AMOUNT
                  #end
                end #alleged entry list ends
               
               xml.ALLLEDGERENTRIESLIST do
                  xml.REMOVEZEROENTRIES "No"
                  xml.ISDEEMEDPOSITIVE "No"
                 
                   if bill.tax_type != "No Tax"
                     tax = bill.bill_taxes.where(:tax_name => ["VAT", "CST"]).first
                     xml.LEDGERNAME tax.tax_rate
                     if tax.tax.tax_type == "Percentage"
                       xml.AMOUNT (tax.tax_rate*0.01).round(2)
                     elsif tax.tax.tax_type == "Flat Amount"
                       xml.AMOUNT tax.tax_rate
                     end
                   else
                     xml.LEDGERNAME
                     xml.AMOUNT 
                   end
                 
                  #if bill.tax_type != "No Tax"
                    #taxes = bill.line_items.pluck(:tax_id)
                    #tax = taxes.compact.first
                    #tax_rate = Tax.where(:id => tax).first.tax_rate
                    #xml.LEDGERNAME tax_rate
                    #xml.AMOUNT (tax_rate*0.01).round(2)
                  #else
                    #xml.LEDGERNAME 
                    #xml.AMOUNT 
                  #end
                end #alleged entry list ends
             end #user_bills each do ends
         end #tally message ends
     end #request data ends 
    end #xml import data ends
  end# xml body ends
end # xml envelope ends
end #xml ends