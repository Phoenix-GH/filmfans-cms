Rails.application.routes.draw do
  devise_for :admins, path: '/panel'
  root to: redirect("/panel")
  require 'sidekiq/web'

  namespace :api do
    namespace :braintree do
      get "/client_token", to: 'braintree#client_token'
      post "/checkout", to: 'braintree#checkout'
    end

    namespace :v2 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
          passwords: 'api/v2/passwords',
          registrations: 'api/v2/registrations',
          sessions: 'api/v2/sessions'
      }
      put 'profiles', to: 'profiles#update'
      post "auth/sign_in/facebook", to: 'facebooks#login'
    end

    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
          omniauth_callbacks: 'api/v1/omniauth_callbacks',
          registrations: 'api/v1/registrations'
      }
      get "fb_login/:fb_token", to: 'omniauth_callbacks#fb_login'
      get 'users/exist', to: 'sessions#exist'
      resources :user_profile, only: [:update]

      resources :addresses, only: [:index, :create, :update, :destroy]
      resource :carousel, only: [] do
        get :home
      end
      resources :categories, only: [:index] do
        get :tree, on: :collection
      end
      resources :channels, only: [:index, :show] do
        member do
          get :feed
          get :videos
          get :trending
        end
        get :feed, on: :collection, to: 'channels#feed_by_key'
        get :discovery, on: :collection
      end
      resources :collections, only: [:index, :show]
      resources :combo_containers, only: [:show]
      resources :feed, only: [:index]
      resources :events, only: [:show]
      resources :followings, only: [:index] do
        post :toggle, on: :collection
      end
      resources :homes, only: [] do
        get :current, on: :collection
      end
      resources :magazines, only: [:index, :show] do
        resources :issues, only: [] do
          get :issue_pages
        end
      end
      resources :media_containers, only: [:index, :show]
      resources :media_owners, only: [:index, :show] do
        member do
          get :feed
          get :videos
        end
        get :discovery, on: :collection
      end
      resources :media_owner_trendings, only: [:index] do
        get :carousels, on: :collection
      end

      resources :posts, only: [:show]
      resources :products, only: [:index, :show] do
        get :learning, on: :collection
        get :learning_count, on: :collection
        get :index_shortened, on: :collection
        get :keyword_search, on: :collection
      end
      resources :products_containers, only: [:show]
      resources :searched_phrases, only: [:index]
      resources :snapped_photos, only: [:index, :create, :destroy] do
        delete :delete_multi, on: :collection
      end
      resources :snapped_products, only: [:index] do
        post :capture, on: :collection
        get 'sub_results/:id', action: :sub_results, on: :collection
        post :feedback, on: :collection
      end
      resources :tv_shows, only: [:index, :show]
      resources :wishlists, only: [:index] do
        post :toggle, on: :collection
        delete :delete_multi, on: :collection
      end
      resources :threed_ars, only: [:show]

      resources :systems, only: [:index] do
        get :exchange_rate, on: :collection
      end

      resources :social_account_followings, only: [:index]
      resources :social_following_feeds, only: [:index], controller: :social_account_following_feeds
      post :social_following_feeds, to: 'social_account_following_feeds#index'
      resources :social_categories, only: [:index]
      resources :social_user_followees, only: [:index] do
        post :delete_multi, on: :collection
        post :create_multi, on: :collection
      end

      resources :reports, only: :none, path: 'query' do
        collection do
          get :sales
        end
      end

      resources :stats do
        post :exec_time, on: :collection
      end

      resources :product_image_indexes, only: [:index], controller: :product_image_indexes

      resources :movies, only: [:index, :show] do
        collection do
          get 'celebs/:id', action: :celebrity
          get 'theatre/:id', action: :theatre
          get :validate_zipcode
          get :validate_geolocation
          get :popular
          get :universal_search
        end
        member do
          get :ticket
          get :trailer
        end
      end

    end

  end

  namespace :json do
    resources :channels, only: [:index]
    resources :collections, only: [:index]
    resources :collection_contents, only: [:index]
    resources :collections_containers, only: [:index]
    resources :events, only: [:index]
    resources :events_containers, only: [:index]
    resources :movies, only: [:index]
    resources :movies_containers, only: [:index]
    resources :home_contents, only: [:index]
    resources :magazines, only: [:index]
    resources :issues, only: [] do
      post :on_pdf_uploaded, on: :member
      get :load_images, on: :member
      post :save_tags, on: :member
      get :load_all_categories, on: :member
      post :set_visible, on: :member
      get :compress_images, on: :collection
    end
    resources :media_containers, only: [:index]
    resources :media_contents, only: [:create, :destroy]
    resources :media_owners, only: [:index]
    resources :media_owner_trendings, only: [:index]
    resources :media_owner_trending_containers, only: [:index]
    resources :products, only: [:index]
    resources :products_containers, only: [:index]
    resources :product_files, only: [:create, :destroy]
    resources :temp_images, only: [:create, :destroy]
    resources :tv_shows, only: [:index]
    resources :benchmarks, only: [:index] do
      get :keywords, on: :collection
      post :update_threshold, on: :collection
    end
  end

  namespace :panel do

    root to: 'dashboard#index'
    resources :admins, only: [:index, :new, :create, :edit, :update, :destroy] do
      put :toggle_active, on: :member
    end
    resources :campaigns
    resources :categories do
      get :untrained, on: :collection
    end

    resources :magazines do
      resources :issues do
        get :upload, on: :member
        get :tags, on: :member
        get :tag_products, on: :member
        get :confirm, on: :member
      end
      get :order, on: :collection
      post :save_order, on: :collection
    end
    resources :tv_shows do
      resources :episodes
      get :order, on: :collection
      post :save_order, on: :collection
    end
    resources :channels do
      resources :tv_shows do
        put :update_images, on: :member
      end
      resources :magazines do
        put :update_images, on: :member
      end

      put :toggle_feed_active, on: :member
      put :toggle_visibility, on: :member
      put :feed_settings, on: :member
      resources :posts, only: :none do
        get :feed, on: :collection
      end
      get :order, on: :collection
      post :save_order, on: :collection
    end
    resources :channel_pictures, only: [:update]
    resources :collections do
      put :sort, on: :member
      put :update_images, on: :member
    end
    resources :collections_containers do
      put :sort, on: :member
    end
    resources :combo_containers do
      put :sort, on: :member
    end
    resources :dashboard
    resources :events do
      put :update_images, on: :member
    end
    resources :events_containers do
      put :sort, on: :member
    end

    resources :movies, only: [:index, :destroy] do
      get :products, on: :member
      patch :products, on: :member, to: 'movies#update_products'
      collection do
        get :gracenote_search
        post :import_gracenote_movie
      end
    end

    resources :movies_containers do
      put :sort, on: :member
    end

    resources :homes do
      put :sort, on: :member
      put :publish, on: :member
      put :unpublish, on: :member
    end
    resources :issue_cover_images, only: [:update]
    resources :magazine_cover_images, only: [:update]
    resources :magazine_background_images, only: [:update]
    resources :tv_show_cover_images, only: [:update]
    resources :tv_show_background_images, only: [:update]

    resources :threed_ars do
      resources :threed_models do
        get :products, on: :member
        patch :products, on: :member, to: 'threed_models#update_products'
      end
    end

    resources :media_containers do
      resources :tags, only: [:new, :create, :destroy]
    end

    resources :media_owners do
      get :cropper_temp, on: :collection
      put :toggle_feed_active, on: :member
      resources :posts, only: :none do
        get :feed, on: :collection
      end
      get :order, on: :collection
      post :save_order, on: :collection
    end
    resources :manual_posts do
      put :update_crop_area, on: :member, to: 'manual_post_image#update'
    end
    resources :media_owner_trendings do
      get :products, on: :member
      patch :products, on: :member, to: 'media_owner_trendings#update_products'
      put :toggle_visibility, on: :member
    end
    resources :media_owner_trending_containers do
      put :sort, on: :member
    end
    resources :media_owner_pictures, only: [:update]
    resources :media_owner_background_images, only: [:update]
    resources :posts, only: [:edit, :update] do
      put :toggle_visibility, on: :member
    end
    resources :products do
      put :toggle_containers_placement, on: :member
      resources :product_files, only: [:new, :create, :edit, :update, :destroy, :show]
      put :toggle_container_active, on: :member
      get :table, on: :collection
      get :categories, on: :member, to: 'products#load_categories'
      put :categories, on: :member, to: 'products#update_categories'
      get :product_detail, on: :member, to: 'products#view_product_detail'
    end
    resources :products_containers do
      put :sort, on: :member
    end
    resources :reports
    resources :orders_history
    resources :support, only: [:index] do
      put :enquiry, on: :collection
    end
    resources :settings, only: [:index] do
      collection do
        patch :update_account
        put :reset_password
        delete :delete_account
      end
    end
    resources :searched_phrases, only: [:index, :destroy]
    resources :systems, only: [] do
      get :get_or_feature_count_threshold, on: :collection
      post :update_or_feature_count_threshold, on: :collection
    end
    resources :benchmarks, only: [:index, :edit, :update] do
      collection do
        get :edit_thresholds
      end
      put :judge, on: :member
    end
    resources :out_of_stock_products, only: [:index]
    resources :benchmark_multi_objects, only: [:index, :create, :edit, :update]

    resources :disney_categories, only: [:index] do
      collection do
        patch :update
      end
    end

    resources :manual_trainings do
      get :csv, on: :collection
      post :train_user_image, on: :member
      delete :train_user_image, on: :member, to: 'manual_trainings#delete_train_user_image'
    end

    resources :social_accounts do
      resources :followings, only: [:index], controller: :social_account_followings do
        member do
          get :edit_categories
          put :update_categories
        end
      end
    end
    resources :social_followings, only: [:index] do
      member do
        get :edit_categories
        put :update_categories
      end
    end
    resources :social_categories do
      get :order, on: :collection
      post :save_order, on: :collection
      resources :social_account_followings, only: :none do
        get :followings, on: :collection
        post :save_order, on: :collection
        post :save_order_top, on: :collection
        put :toggle_trending, on: :collection
      end
    end

    resources :product_keywords do
    end

    resources :product_image_indexes, only: [:index] do
      post :export_now, on: :collection
    end

    resources :movie_celebrities, only: [:index, :edit, :update] do
    end

    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == 'sidekiq' && password == 'Oe0Ohso1'
    end
    mount Sidekiq::Web, at: "/sidekiq"
  end
end
