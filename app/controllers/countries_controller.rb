class CountriesController < ApplicationController
  def signatures
    @country_code = params[:country_code]&.upcase
    raise ActiveRecord::RecordNotFound unless Signature::COUNTRY_CODES.include?(@country_code)
    @signatures_by_place = Signature.count_by_place_for_country(@country_code)
  end
end
