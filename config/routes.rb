Rails.application.routes.draw do
  get '/' => 'home#index', as: :home

  resources :signatures, only: [:new, :create] do
    get 'thank-you', on: :collection
  end
end
