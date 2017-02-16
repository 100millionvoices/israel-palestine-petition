Rails.application.routes.draw do
  get '/' => 'home#index', as: :home

  resources :signatures, only: [:new, :create] do
    get 'thank-you', on: :collection
    get ':token/confirm', on: :collection,  action: :confirm, as: :confirm
  end
end
