class HomeController < ApplicationController
  before_action :fetch_current_country_code, only: :index

  def locale_redirect
    # the redirect is handled by set_locale
  end

  def index
    @signature_count_for_country = Signature.count_for_country_code(@country_code)
    @signature_count = Signature.confirmed.count
  end

  protected

  def fetch_current_country_code
    ip_location = fetch_ip_location
    return unless ip_location
    @country_code = ip_location.country&.iso_code
  end
end
