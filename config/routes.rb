Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :keys, :only => [:show], :path => "tonalite" do
    resources :chord_qualities, :only => [:index, :show], :path => "qualite"
    resources :chords, :only => [:index, :show], :path => "accords" do
      get :staff, :on => :member
    end

    resources :scales, :only => [:index, :show], :path => "gammes" do
      resources :modes, :only => [:index, :show], :path => "modes"
    end
  end

  resources :scales, :only => [:index, :show], :path => "gammes" do
    get :staff, :on => :member
    resources :modes, :only => [:index, :show] do
      get :staff, :on => :member
    end
  end

  resources :chords, :only => [:index, :show], :path => "accords" do
    get :staff, :on => :member
  end

  resources :intervals, :only => [:index, :show], :path => "intervales" do
    get :staff, :on => :member
  end

  resources :notes, :only => [:index, :show] do
    get :staff, :on => :member
  end

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
