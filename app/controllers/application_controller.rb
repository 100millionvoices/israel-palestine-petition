class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  force_ssl if: :ssl_configured?

  def ssl_configured?
    !Rails.env.development?
  end

  def fetch_ip_location
    GeoIpLookup.fetch_location_from_ip(request.remote_ip)
  rescue IPAddr::InvalidAddressError
  end
end
