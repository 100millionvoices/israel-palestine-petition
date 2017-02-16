class SignaturesController < ApplicationController
  def new
    @signature = Signature.new(signature_params_from_ip_location)
  end

  def create
    @signature = Signature.new(signature_params.merge(ip_address: request.remote_ip))
    if @signature.save
      UserMailer.confirm_signature(@signature).deliver_now # TODO deliver_later
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
    ip_location = GeoIpLookup.fetch_location_from_ip(request.remote_ip)
    return unless ip_location
    { place: ip_location.city&.name, country_code: ip_location.country&.iso_code }
  rescue IPAddr::InvalidAddressError
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
