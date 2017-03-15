Rails.application.routes.draw do
  get '/' => 'home#locale_redirect', as: :root

  scope '/:locale' do
    get '/' => 'home#index', as: :home
    get '/faq' => 'home#faq', as: :faq
    get '/about-us' => 'home#about_us', as: :about_us

    resources :signatures, only: [:index, :new, :create] do
      get 'thank-you', on: :collection
      get ':token/confirm', on: :collection,  action: :confirm, as: :confirm
      get 'countries/:country_code' => 'countries#signatures', on: :collection, as: :country
    end
  end
end
