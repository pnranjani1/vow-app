authorization do
  role :admin do
    has_permission_on [:authusers, :addresses, :bank_details, :bills, :clients, :customers, :invitations, :main_categories, :memberships, :products, :taxes], :to => [:index, :new, :create, :edit, :show, :update, :destroy, :admin_new, :admin_create, :admin_update, :change_role, :client_new, :client_create, :local_sales, :interstate_sales, :tally_import, :user_category, :user_customer, :product_category, :activate_user, :de_activate_user]
    has_permission_on [:dashboards], :to => [:admin_dashboard]
   # has_permission_on [:new, :create, :show, :edit, :index, :update, :destroy]
  end
  
  
  role :client do
    has_permission_on [:authusers, :invitations, :bank_details, :memberships, :addresses], :to => [:index, :new, :show, :create, :edit, :update, :destroy, :activate_user, :de_activate_user, :change_role, :client_new, :client_create, :admin_edit, :admin_update]
    has_permission_on [:dashboards] , :to => [:client_dashboard]
    has_permission_on [:homepage], :to => [:index]
    has_permission_on [:clients], :to => [:update, :user_role]
    has_permission_on [:bills], :to => [:user_bill_summary]
     end
  
  
   # has_permission_on [:products], :to => [:new, :create, :edit, :update, :destroy, :show, :product_user]
  #  has_permission_on [:customers], :to => [:new, :create, :edit, :update, :destroy, :show, :user_customer]
   # has_permission_on [:bills], :to => [:new, :create, :show, :local_sales, :intersate_sales, :tally_import, :user_bill]
    
   
 
  
  
  role :user do
    has_permission_on [ :addresses, :memberships, :bank_details,  :usercategories], :to =>[:index, :new, :create, :show, :edit, :update, :destroy, :client_create, :product_user, :user_bill, :change_role]
    #has_permission_on [:users], :to => [:user_new, :user_create ,:show, :edit, :update]
    has_permission_on [:dashboards], :to => [:user_dashboard]
    has_permission_on [:products], :to => [:new, :create, :show, :edit, :update, :destroy, :product_user, :product_import]
    has_permission_on [:customers], :to => [:new, :create, :show, :edit, :update, :destroy, :user_customer, :customer_import]
    has_permission_on [:bills], :to => [:new, :create, :show, :local_sales, :intersate_sales, :tally_import, :user_bill]
    has_permission_on [:authusers], :to => [:client_edit, :client_update]
 #   has_permission_on [:main_categories], :to => [:index]
       
  end
  
  role :Guest do
    has_permission_on [:homepage], :to => [:index]
  end
end
