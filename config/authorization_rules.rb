authorization do
  role :admin do
    has_permission_on [:authusers, :memberships, :bankdetails, :addresses, :clients, :users, :main_categories, :usercategories, :customers, :homepage, :products, :taxes], :to => [:index, :new, :create, :edit, :show, :update, :destroy, :admin_new, :admin_create, :admin_update, :user_category, :user_customer, :product_category]
    has_permission_on [:dashboards], :to => [:admin_dashboard]
  end
  
  role :Client do
    has_permission_on [:authusers, :users, :usercategories, :main_categories], :to => [:index, :new, :show, :create, :edit, :update, :destroy, :client_new, :client_create]
    has_permission_on [:dashboards] , :to => [:client_dashboard, :user_dashboard]
    has_permission_on [:homepage], :to => [:index]
  end
  
  role :User do
    has_permission_on [:usercategories, :customers, :products, :taxes], :to =>[:index, :new, :create, :show, :edit, :update, :destroy]
    has_permission_on [:m_categories], :to =>[:index]
    has_permission_on [:users], :to => [:edit, :update, :show]
    has_permission_on [:dashboards], :to => [:user_dashboard]
    has_permission_on [:homepage], :to => [:index]
  end
  
  role :Guest do
    has_permission_on [:homepage], :to => [:index]
  end
end
