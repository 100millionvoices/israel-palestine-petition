class HomeController < ApplicationController
  skip_before_action :display_maintenance_page, only: :maintenance
  before_action :fetch_current_country_code, only: :index
  caches_action :index, cache_path: -> { { country_code: @country_code } }, expires_in: 5.minutes
  caches_action :about_us, :faq, expires_in: 10.minutes

  def locale_redirect
    # the redirect is handled by set_locale
  end

  def index
    @signature_count_for_country = Signature.cached_count_for_country_code(@country_code)
    @top_places_for_country = fetch_top_places_for_country(@country_code, @signature_count_for_country)
    @signature_count = Signature.cached_count_total
  end

  def maintenance
    redirect_to home_path unless maintenance_page_enabled?
  end

  protected

  def fetch_current_country_code
    ip_location = fetch_ip_location
    return unless ip_location
    @country_code = ip_location.country&.iso_code
  end

  def fetch_top_places_for_country(country_code, signature_count_for_country)
    if country_code && signature_count_for_country.positive?
      Signature.cached_count_by_place_for_country(country_code, 4)
    end
  end
end
