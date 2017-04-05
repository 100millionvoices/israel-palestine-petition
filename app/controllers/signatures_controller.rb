class SignaturesController < ApplicationController
  include Captcha

  def index
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
      place = ip_location.city&.name(language.downcase.split('-', 2).first)
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
    ReverseGeocoder.fetch_location_name_from_lat_lng(lat, lng, language)
  end
end
