LEMN::Application.routes.draw do
  resources :payments do
    collection do
      post :autocomplete_for_partner
    end
  end

  resources :assistances

  resources :partners

  devise_for :users

  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end

  root :to => 'users#index'
end
