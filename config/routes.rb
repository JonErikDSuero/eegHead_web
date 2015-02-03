Rails.application.routes.draw do

  get '/auth/:provider/callback', to: 'sessions#create'

  root 'home#index'

  # API ~~~~~~~~~~~~~~~~~~~~~~~ (start)
  scope module: :api do

    namespace :v0 do
      resources :help
    end

    namespace :v1 do
      resources :waves do
        collection do
          get 'updates_stream'
          post 'insert'
          post 'graph_points'
        end
      end

      resources :video_sessions do
        collection do
          post 'insert'
          post 'delete_all'
          post 'graph_points'
          delete 'master_delete_all'
        end
      end

      resources :videos do
        collection do
          post 'insert'
          post 'delete'
        end
      end

      resources :wave_logs, path: :wavelogs do
        collection do
          post 'insert'
        end
      end

    end

  end
  # API ~~~~~~~~~~~~~~~~~~~~~~~ (end)


  # SITE ~~~~~~~~~~~~~~~~~~~~~~~ (start)
  scope module: :site do

    resources :waves do
      collection do
        get 'graph'
        get 'fake_headset'
      end
    end

    resources :videos do
      collection do
        get 'watch'
      end
    end

  end
  # SITE ~~~~~~~~~~~~~~~~~~~~~~~ (end)

  # SESSIONS ~~~~~~~~~~~~~~~~~~~ (start)

  resources :users

  get 'signup' => 'users#new'
  get 'login'  => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'


  # SESSIONS ~~~~~~~~~~~~~~~~~~~ (end)

end

# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".

# You can have the root of your site routed with "root"

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
