Rails.application.routes.draw do
  get '/' => 'home#locale_redirect', as: :root

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  # Protect against timing attacks:
  # - See https://codahale.com/a-lesson-in-timing-attacks/
  # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
  # - Use & (do not use &&) so that it doesn't short circuit.
  # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
  ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?
  mount Sidekiq::Web, at: '/sidekiq'

  scope '/:locale' do
    get '/' => 'home#index', as: :home
    get '/faq' => 'home#faq', as: :faq
    get '/about-us' => 'home#about_us', as: :about_us

    resources :signatures, only: [:index, :new, :create] do
      get 'page/:page', action: :index, on: :collection
      get 'thank-you', on: :collection
      get ':token/confirm', on: :collection,  action: :confirm, as: :confirm
      get 'counts', on: :collection,  action: :counts, format: :json
      get 'countries/:country_code' => 'countries#signatures', on: :collection, as: :country
    end
  end
end
