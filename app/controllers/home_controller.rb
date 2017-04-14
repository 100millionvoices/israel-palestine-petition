class HomeController < ApplicationController
  before_action :fetch_current_country_code, only: :index
  caches_action :index, cache_path: -> { { country_code: @country_code } }
  caches_action :about_us, :faq, expires_in: 5.minutes

  def locale_redirect
    # the redirect is handled by set_locale
  end

  def index
    @signature_count_for_country = Signature.cached_count_for_country_code(@country_code)
    @signature_count = Rails.cache.fetch('signature_count_all') { Signature.confirmed.count }
  end

  protected

  def fetch_current_country_code
    ip_location = fetch_ip_location
    return unless ip_location
    @country_code = ip_location.country&.iso_code
  end
end
