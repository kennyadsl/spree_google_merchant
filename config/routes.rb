Rails.application.routes.draw do
  resources :products, only: [] do
    collection do
      get :google_merchant
    end
  end

  namespace :admin do
    resource :google_merchants
  end
end
