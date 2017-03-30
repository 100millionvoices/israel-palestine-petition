class SignaturesController < ApplicationController
  include Captcha

  def index
    @signatures = Signature.count_by_country_code
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
    place || ip_location.city&.name(I18n.locale) || ip_location.city&.name
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
end
