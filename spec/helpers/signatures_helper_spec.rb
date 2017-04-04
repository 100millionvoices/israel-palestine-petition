require 'rails_helper'

describe SignaturesHelper do
  describe 'signature_count_for_country' do
    let!(:ghana)     { create :ghana }
    let!(:pending)   { create :pending_signature_gh }
    let!(:confirmed) { create :confirmed_signature_gh }

    it 'counts confirmed signatures for a country' do
      expect(helper.signature_count_for_country(ghana)).to eq(1)
    end
  end
end
