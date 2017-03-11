require 'rails_helper'

describe SignaturesHelper do
  describe 'signature_count_by_country' do
    it 'converts a count hash keyed by country code to an array with country name' do
      country_code_hash = { 'GH' => 2, 'DE' => 1 }
      expect(helper.signature_count_by_country(country_code_hash)).to eq([['Germany', 1], ['Ghana', 2]])
    end
  end
end
