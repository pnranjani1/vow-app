Rails.application.routes.draw do
 devise_for :authusers, path_names:{sign_in: "login", sign_out: "logout"}
  # :controllers => {:registrations => 'registrations'}
  root 'home_page#index'
  
  devise_scope :authuser do
    
   get 'authusers/admin_new' => 'authusers#admin_new'
   post 'authusers/admin_create' => 'authusers#admin_create'
    get 'authusers/client_new' => 'authusers#client_new'
    post 'authusers/client_create' => 'authusers#client_create'
 end
  
  get 'products/product_category'
  get 'customers/user_customer'
  get 'categories/user_category'
  get 'dashboards/admin_dashboard'
  get 'dashboards/client_dashboard'
  get 'dashboards/user_dashboard'
  resources :users
  resources :customers
  resources :main_categories
  resources :usercategories
  resources :taxes
  resources :products
  resources :dashboards
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
