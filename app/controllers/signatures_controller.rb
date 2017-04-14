class SignaturesController < ApplicationController
  include Captcha
  caches_action :index, expires_in: 5.minutes
  caches_action :thank_you, expires_in: 10.minutes

  def index
    raise ActiveRecord::RecordNotFound if params[:page].present? && !(params[:page] =~ /\A\d+\z/)
    @countries = Country.with_confirmed_signatures.order("name_#{I18n.locale}").page(params[:page]).per(20)
  end

  def new
    @signature = Signature.new(signature_params_from_ip_location)
  end

  def create
    @signature = Signature.new(signature_params.merge(ip_address: request.remote_ip))
    if (captcha_disabled? || verify_captcha) && @signature.save
      UserMailer.confirm_signature(@signature, I18n.locale.to_s).deliver_later
      redirect_to thank_you_signatures_path
    else
      render :new
    end
  end

  def confirm
    signature = fetch_signature_for_confirmation
    if signature
      signature.confirm!
    else
      render(:confirm_error) && return
    end
  end

  protected

  def signature_params_from_ip_location
    ip_location = fetch_ip_location
    return unless ip_location

    { place: place_in_user_preferred_language(ip_location),
      country_code: ip_location.country&.iso_code }
  end

  def place_in_user_preferred_language(ip_location)
    place = nil
    http_accept_language.user_preferred_languages.each do |language|
      place = GeoIpLookup.fetch_place_in_preferred_language(ip_location, language)
      break if place
    end
    place || place_from_reverse_geocode(ip_location)
  end

  def fetch_signature_for_confirmation
    return if params[:token].blank?
    Signature.find_by(signing_token: params[:token])
  end

  def signature_params
    params.require(:signature).permit(:name, :email, :place, :country_code).tap do |sanitized|
      sanitized[:name]&.strip!
      sanitized[:place]&.strip!
      sanitized[:email]&.strip!
    end
  end

  def place_from_reverse_geocode(ip_location)
    return unless http_accept_language.user_preferred_languages.any? && ip_location.city&.name

    lat = ip_location.location&.latitude
    lng = ip_location.location&.longitude
    language = http_accept_language.user_preferred_languages.first.downcase.split('-', 2).first
    Rails.cache.fetch("location_name_in_#{language}_from_lat_#{lat}_lng_#{lng}", expires_in: 10.minutes) do
      ReverseGeocoder.fetch_location_name_from_lat_lng(lat, lng, language)
    end
  end
end
