# see https://developers.google.com/maps/documentation/geocoding/intro#ReverseGeocoding
class ReverseGeocoder
  GEOCODE_URL = 'https://maps.googleapis.com/maps/api/geocode/json'.freeze

  def self.fetch_location_name_from_lat_lng(lat, lng, language)
    return unless lat.present? && lng.present? && language.present?

    query = { latlng: "#{lat},#{lng}", result_type: 'locality', language: language, key: ENV['GOOGLE_API_KEY'] }
    response = HTTParty.get(GEOCODE_URL, query: query)
    hash_response = JSON.parse(response.body)
    response_status = hash_response['status']
    place_name = nil

    if response_status == 'OK'
      place_name = extract_place_name_from_response(hash_response)
    elsif response_status != 'ZERO_RESULTS'
      handle_error("#{response_status} #{hash_response['error_message']}", :error, query)
    end

    place_name
  rescue StandardError => e
    handle_error(e, :error, query)
  end

  def self.handle_error(error, level, options = {})
    Raven.capture_message(error, level: level, extra: options)
  end

  def self.extract_place_name_from_response(hash_response)
    first_result = hash_response['results'].first
    return unless first_result || first_result['address_components']

    place = nil
    first_result['address_components'].each do |ac|
      if ac['types'].include?('locality')
        place = ac['long_name']
        break
      end
    end
    place
  end
end
