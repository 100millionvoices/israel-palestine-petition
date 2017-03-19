class CountriesController < ApplicationController
  def signatures
    @country_code = params[:country_code]&.upcase
    if Signature::COUNTRY_CODES.exclude?(@country_code) || !(params[:country_code] =~ /^[a-z]*$/)
      raise ActiveRecord::RecordNotFound
    end

    @country = Country.find_by(country_code: @country_code)
    @signatures_by_place = Signature.count_by_place_for_country(@country_code)
  end
end
