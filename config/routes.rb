Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :categories, only: [:index, :create, :update]
      resources :posts, only: [:index, :create, :update]
    end
  end
end
