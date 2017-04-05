require 'rails_helper'

describe ReverseGeocoder do
  describe '.fetch_location_name_from_lat_lng' do
    let(:url) { ReverseGeocoder::GEOCODE_URL + "?key=&language=it&latlng=45.466084,9.186313&result_type=locality" }

    it 'returns a place name from lat lng' do
      stub_request(:get, url).to_return(status: 200, body: fixture_file('milano_geo_code.json'))
      place_name = ReverseGeocoder.fetch_location_name_from_lat_lng(45.466084, 9.186313, 'it')
      expect(place_name).to eq('Milano')
    end

    it 'returns nil if there is a status of ZERO_RESULTS' do
      stub_request(:get, url).to_return(status: 200, body: fixture_file('milano_geo_code_no_results.json'))
      expect(Raven).to_not receive(:capture_message)

      place_name = ReverseGeocoder.fetch_location_name_from_lat_lng(45.466084, 9.186313, 'it')
      expect(place_name).to be_nil
    end

    it 'returns nil if there is a status of INVALID_REQUEST' do
      stub_request(:get, url).to_return(status: 200, body: fixture_file('milano_geo_code_invalid_request.json'))
      expect(Raven).to receive(:capture_message).with('INVALID_REQUEST Bad news', anything)

      place_name = ReverseGeocoder.fetch_location_name_from_lat_lng(45.466084, 9.186313, 'it')
      expect(place_name).to be_nil
    end
  end
end
