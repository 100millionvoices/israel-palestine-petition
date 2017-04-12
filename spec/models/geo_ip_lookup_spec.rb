require 'rails_helper'

describe GeoIpLookup do
  describe '.fetch_place_in_preferred_language' do

    it 'returns a place name in German' do
      place_name = GeoIpLookup.fetch_place_in_preferred_language(cologne_ip_location, 'de-CH')
      expect(place_name).to eq('Köln')
    end

    it 'returns a place name in Portuguese' do
      place_name = GeoIpLookup.fetch_place_in_preferred_language(cologne_ip_location, 'pt-PT')
      expect(place_name).to eq('Colônia')
    end

    it 'returns nil if language is not found' do
      place_name = GeoIpLookup.fetch_place_in_preferred_language(cologne_ip_location, 'klingon')
      expect(place_name).to be_nil
    end
  end
end
