Rails.application.routes.draw do
  resources :auth_user_categories
  get 'bills/esnget'

 devise_for :authusers, path_names:{sign_in: "login", sign_up: "cmon_let_me_in"},
  :controllers => { :invitations => 'invitations' , :registrations => 'registrations'}
  #controllers: {invitations: 'authusers/invitations'}
  
 
  root 'home_page#index'
   
  devise_scope :authuser do
    
    get 'auth_user_categories/product_list' => 'auth_user_categories#product_list'
    get 'customers/customer_download' => 'customers#customer_download'
    get 'products/usercategory_product'  =>  'products#usercategory_product'
    get 'products/product_download' => 'products#product_download'
    get 'authusers/change_role' => 'authusers#change_role'
   get 'authusers/admin_new' => 'authusers#admin_new'
   post 'authusers/admin_create' => 'authusers#admin_create'
    get 'authusers/client_new' => 'authusers#client_new'
    patch 'authusers/client_create' => 'authusers#client_create'
    get 'authusers/admin_edit' => 'authusers#admin_edit'
    patch 'authusers/admin_update' => 'authusers#admin_update'
    
    get 'authusers/force_password_change' => 'authusers#force_password_change'
   # get 'authusers/:id/admin_edit' => 'authusers#admin_edit', :as => "admin_edit"
    #patch 'authusers/:id/admin_update' => 'authusers#admin_update', :as => "admin_update"
    
    get 'authusers/client_edit' => 'authusers#client_edit'
    patch 'authusers/client_update' => 'authusers#client_update'
    
  #  put 'authusers/activate_user' => 'authusers#activate_user'
     put 'authusers/:id/activate' => 'authusers#activate_user', :as => 'activate_user'
    put 'authusers/:id/de_activate' => 'authusers#de_activate_user', :as => 'de_activate_user'
    get 'authusers/user_management' => 'authusers#user_management'
    get 'authusers/user_profile_picture' => 'authusers#user_profile_picture'
    get 'authusers/secondary_user' => 'authusers#secondary_user'
    post 'authusers/secondary_user_create' => 'authusers#secondary_user_create'
 end
  
    put 'authusers/change_role_update' => 'authusers#change_role_update'
  #map.readpdf "/home_page/readpdf", :controller => "home_page", :action => "readpdf"
#  map.connect 'Terms of Service VatOnWheels.pdf', :controller=>'home_page', :action=>'readpdf'
  post 'admins/create'
  get 'clients/user_role'
  put 'clients/update_user_role'
  get 'bills/:id/user_pdf' => 'bills#user_pdf', :as => "user_bill_pdf"
  get 'bills/:id/user_billing_report' => 'bills#user_billing_report', :as => "user_pdf_bill_report"
  get 'bills/user_bill_summary'
  get 'bills/client_bill_summary'
  get 'bills/tally_import'
  post 'customers/customer_import'
  get 'products/product_user'
  post 'products/product_import'
  post 'products/product_import_result'
  get 'customers/user_customer'
  get 'categories/user_category'
  get 'dashboards/admin_dashboard'
  get 'dashboards/client_dashboard'
  get 'dashboards/user_dashboard'
  get 'bills/user_bill'
  get 'bills/local_sales'
  get 'bills/interstate_sales'
  get 'bills/bill_local_sales_reports'
  get 'bills/bill_interstate_sales_reports'
  get 'bills/bill_tally_import_reports'
  get 'products/product_import_report'
  get 'customers/customer_import_report'
  get 'bills/:id/bill_details_client' => "bills#bill_details_client" , as: "bill_details_client"
  get 'home_page/read_pdf'
  get 'bills/user_billing'
 # get 'bills/user_billing_report'
  get 'bills/client_monthly_bill'
  get 'bills/client_billing_report'
  post 'customers/newcustomer_in_bill'
  post 'products/newproduct_in_bill'
  post 'main_categories/category_import'
  get 'main_categories/category_import_report'
  get 'main_categories/category_download'
 # get 'clients/:id/referred'  => 'clients#referred'
  get 'clients/referred'
  #patch 'clients/referral_update' => 'clients#referral_update'
  patch 'clients/referral_update'
  get 'referrals/referral_bill'
  get 'referrals/client_acquisition'
  get 'referrals/client_acquisition_report'
  get 'bills/:id/pdf_format' => 'bills#pdf_format', :as => "pdf_format"
  patch 'bills/:id/pdf_format_select' => 'bills#pdf_format_select', :as => "pdf_format_select"
  get 'referrals/:id/referral_pdf_bill' => 'referrals#referral_pdf_bill', :as => "referral_pdf_bill"
  get 'referrals/:id/referral_pdf_bill_report' => 'referrals#referral_pdf_bill_report', :as => "referral_pdf_bill_report"
  get 'bills/local'
  get 'bills/local_report'
  get 'bills/interstate'
  get 'bills/interstate_report'
  get 'dashboards/secondary_user_dashboard'
  get 'bills/tally_import_report'
  get 'bills/tally_import_excel'
  get 'authusers/invoice_format'
  patch 'authusers/invoice_format_update'
  get 'bills/secondary_user_bill'
  get 'bills/secondary_user_activity_report'
  get 'bills/get_tin'
  post 'authusers/:id/invite_user_again' => 'authusers#invite_user_again', as: "invite_user"
  get 'bills/captcha'
  patch 'bills/:id/captcha_image' => "bills#captcha_image", :as => "captcha_image"
  patch 'authusers/:id/update_profile_picture' => 'authusers#update_profile_picture', as: "update_user_profile_picture"
  get 'bills/:id/client_pdf_bill' => 'bills#client_pdf_bill' , as: "client_pdf_bill"
  get 'tin_numbers/download_tinnumber' => 'tin_numbers#download_tinnumber'
  get 'taxes/download_tax' => "taxes#download_tax"
  get 'main_categories/download_commodity' => 'main_categories#download_commodity'
  get 'products/download_product' => "products#download_product"
  get 'customers/download_customer' => "customers#download_customer"
  get 'bills/download_excel' => 'bills#download_excel'
  post 'customers/new_customer_in_edit'
  post 'products/new_product_in_edit'
  get 'other_charges_informations/download_other_charges' => "other_charges_informations#download_other_charges"
  post 'bills/sub_user_bill'
  get 'bills/:id/send_mail' => "bills#send_mail", as: "send_mail"
 
  
 # patch 'bills/pdf_format_select'
    
 
  
  resources :authusers  
  resources :users
  resources :bills do 
    collection do 
      post :generate_esugan
    end
  end
  resources :customers
  resources :main_categories
  resources :usercategories
  resources :taxes
  resources :products
  resources :dashboards
  resources :line_items
  resources :bank_details
  resources :memberships
  resources :addresses
  #resources :userprofiles
   resources :clients
  resources :admins
  resources :enquiry_forms
  resources :referrals
  resources :referral_types
  resources :tin_numbers 
  resources :service_taxes
  resources :other_charges_informations
  resources :bill_taxes
  
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
