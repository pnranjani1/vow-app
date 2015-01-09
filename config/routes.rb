Rails.application.routes.draw do
  resources :auth_user_categories
  get 'bills/esnget'

 devise_for :authusers, path_names:{sign_in: "login", sign_up: "cmon_let_me_in"},
  :controllers => { :invitations => 'invitations' }
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
    post 'authusers/client_create' => 'authusers#client_create'
    
    get 'authusers/force_password_change' => 'authusers#force_password_change'
    get 'authusers/:id/admin_edit' => 'authusers#admin_edit', :as => "admin_edit"
    patch 'authusers/:id/admin_update' => 'authusers#admin_update', :as => "admin_update"
    
    get 'authusers/:id/client_edit' => 'authusers#client_edit', :as => "client_edit"
    patch 'authusers/:id/client_update' => 'authusers#client_update', :as => "client_update"
    
  #  put 'authusers/activate_user' => 'authusers#activate_user'
     put 'authusers/:id/activate' => 'authusers#activate_user', :as => 'activate_user'
    put 'authusers/:id/de_activate' => 'authusers#de_activate_user', :as => 'de_activate_user'
 end
  
    put 'authusers/change_role_update' => 'authusers#change_role_update'
  
  
  post 'admins/create'
  get 'clients/user_role'
  put 'clients/update_user_role'
  get 'bills/user_bill_summary'
  get 'bills/client_bill_summary'
  get 'bills/tally_import'
  post 'customers/customer_import'
  get 'products/product_user'
  post 'products/product_import'
  get 'customers/user_customer'
  get 'categories/user_category'
  get 'dashboards/admin_dashboard'
  get 'dashboards/client_dashboard'
  get 'dashboards/user_dashboard'
  get 'bills/user_bill'
  get 'bills/local_sales'
  get 'bills/interstate_sales'
  get 'bills/bill_reports'
  resources :authusers
  resources :users
  resources :bills
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
