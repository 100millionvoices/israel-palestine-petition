Rails.application.routes.draw do
  get '/' => 'home#index', as: :home
end
