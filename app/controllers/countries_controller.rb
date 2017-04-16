class CountriesController < ApplicationController
  caches_action :show, expires_in: 5.minutes
  caches_action :signature_counts, expires_in: 11.seconds

  def show
    @country_code = fetch_country_code
    @country = Country.find_by(country_code: @country_code)
    @signatures_by_place = Signature.cached_count_by_place_for_country(@country_code)
  end

  def signature_counts
    country_code = fetch_country_code
    signatures_by_place = Signature.cached_count_by_place_for_country(country_code)
    render json: { total: Signature.cached_count_for_country_code(country_code),
                   places: signatures_by_place }
  end

  protected

  def fetch_country_code
    country_code = params[:country_code]&.upcase
    if Signature::COUNTRY_CODES.exclude?(country_code) || !(params[:country_code] =~ /^[a-z]*$/)
      raise ActiveRecord::RecordNotFound
    end
    country_code
  end
end
