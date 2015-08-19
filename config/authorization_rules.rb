authorization do
  role :admin do
    has_permission_on [:authusers, :addresses, :bank_details, :bills, :clients, :customers, :invitations, :main_categories, :memberships, :products, :taxes, :referrals, :tin_numbers, :service_taxes], :to => [:index, :new, :create, :edit, :show, :update, :destroy, :admin_new, :admin_create, :admin_update, :change_role, :client_new, :client_create, :local_sales, :interstate_sales, :tally_import, :user_category, :user_customer, :product_category, :activate_user, :de_activate_user, :client_bill_summary, :bill_details_client, :force_password_change, :client_monthly_bill, :user_billing_report, :client_billing_report, :referred, :referral_update, :referral_bill ]
    has_permission_on [:dashboards], :to => [:admin_dashboard]
    has_permission_on [:main_categories], :to => [:category_import, :category_import_report]
   # has_permission_on [:new, :create, :show, :edit, :index, :update, :destroy]
  end
  
  
  role :client do
    has_permission_on [:authusers, :invitations, :bank_details, :memberships, :addresses], :to => [:index, :new, :show, :create, :edit, :update, :destroy, :activate_user, :de_activate_user, :change_role, :client_new, :client_create, :admin_edit, :admin_update, :user_profile_picture]
    has_permission_on [:dashboards] , :to => [:client_dashboard]
    has_permission_on [:homepage], :to => [:index]
    has_permission_on [:clients], :to => [:update, :user_role]
    has_permission_on [:bills], :to => [:user_bill_summary, :bill_information_client, :user_billing, :user_billing_report]
     end
  
  
   # has_permission_on [:products], :to => [:new, :create, :edit, :update, :destroy, :show, :product_user]
  #  has_permission_on [:customers], :to => [:new, :create, :edit, :update, :destroy, :show, :user_customer]
   # has_permission_on [:bills], :to => [:new, :create, :show, :local_sales, :intersate_sales, :tally_import, :user_bill]
    
   
 
  
  
  role :user do
    has_permission_on [ :addresses, :memberships, :bank_details,  :usercategories], :to =>[:index, :new, :create, :show, :edit, :update, :destroy, :change_role]
    #has_permission_on [:users], :to => [:user_new, :user_create ,:show, :edit, :update]
    has_permission_on [:dashboards], :to => [:user_dashboard]
    has_permission_on [:products], :to => [:new, :create, :show, :edit, :update, :product_user, :product_import, :product_import_report, :product_import_result]
    has_permission_on [:customers], :to => [:new, :create, :show, :edit, :update, :destroy, :user_customer, :customer_import, :customer_import_report]
    has_permission_on [:bills], :to => [:new, :create, :show, :local_sales, :interstate_sales, :tally_import, :user_bill, :bill_reports, :generate_esugan, :local_sales_reports, :interstate_sales_reports, :tally_import_reports, :bill_local_sales_reports, :bill_interstate_sales_reports, :bill_tally_import_reports, :pdf_format, :pdf_format_select, :tally_import_report, :tally_import_excel, :invoice_format, :invoice_format_update]
    has_permission_on [:authusers], :to => [:force_change_password, :client_edit, :client_update, :change_role, :client_create, :client_new, :user_profile_picture, :secondary_user, :secondary_user_create, :invoice_format_update]
 #   has_permission_on [:main_categories], :to => [:index]
       
  end
  
  role :secondary_user do
     has_permission_on [:usercategories], :to =>[:index, :new, :create, :show, :edit, :update]
    #has_permission_on [:users], :to => [:user_new, :user_create ,:show, :edit, :update]
    has_permission_on [:dashboards], :to => [:secondary_user_dashboard]
    has_permission_on [:products], :to => [:new, :create, :show, :edit, :update, :product_user, :product_import, :product_import_report, :product_import_result]
    has_permission_on [:customers], :to => [:new, :create, :show, :edit, :update, :destroy, :user_customer, :customer_import, :customer_import_report]
    has_permission_on [:bills], :to => [:new, :create, :show, :local_sales, :interstate_sales, :tally_import, :user_bill, :bill_reports, :generate_esugan, :local_sales_reports, :interstate_sales_reports, :tally_import_reports, :bill_local_sales_reports, :bill_interstate_sales_reports, :bill_tally_import_reports, :pdf_format, :pdf_format_select, :tally_import_report, :tally_import_excel, :invoice_format, :invoice_format_update]
    has_permission_on [:authusers], :to => [:force_change_password, :invoice_format_update, :client_edit, :client_update]
   
  end
  
  role :Guest do
    has_permission_on [:homepage], :to => [:index]
    has_permission_on [:authusers], :to => [:force_password_change]
  end
end
