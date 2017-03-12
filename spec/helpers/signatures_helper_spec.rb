require 'rails_helper'

describe SignaturesHelper do
  describe 'signature_count_by_country' do
    let(:country_code_hash) { { 'GH' => 2, 'DE' => 1 } }

    context 'en locale' do
      it 'converts a count hash keyed by country code to an array with country name' do
        I18n.locale = :en
        expect(helper.signature_count_by_country(country_code_hash)).to eq([['Germany', [1, 'de']], ['Ghana', [2, 'gh']]])
      end
    end

    context 'de locale' do
      it 'converts a count hash keyed by country code to an array with country name' do
        I18n.locale = :de
        expect(helper.signature_count_by_country(country_code_hash)).to eq([['Deutschland', [1, 'de']], ['Ghana', [2, 'gh']]])
      end
    end
  end
end
