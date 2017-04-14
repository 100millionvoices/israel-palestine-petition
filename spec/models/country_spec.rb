require 'rails_helper'

describe Country do
  describe 'validations' do
    it { should validate_presence_of(:name_en) }
    it { should validate_presence_of(:country_code) }
  end

  describe 'scopes' do
    describe 'with_confirmed_signatures' do
      it 'returns countries with has_confirmed_signatures set to true' do
        germany = create :germany, has_confirmed_signatures: false
        ghana = create :ghana, has_confirmed_signatures: true
        expect(Country.with_confirmed_signatures).to eq([ghana])
      end
    end
  end

  describe '#signature_count' do
    it 'returns the count from Signature' do
      country = Country.new(country_code: 'GH')
      expect(Signature).to receive(:cached_count_for_country_code).with('GH')
      country.signature_count
    end
  end

  describe 'target_reached?' do
    let(:country) { Country.new(population: 1_000) }

    it 'is true' do
      expect(country).to receive(:signature_count).and_return(10)
      expect(country.target_reached?).to eq(true)
    end

    it 'is false' do
      expect(country).to receive(:signature_count).and_return(9)
      expect(country.target_reached?).to eq(false)
    end
  end

  describe '#target_signature_count' do
    it 'is nil if population is nil' do
      expect(Country.new.target_signature_count).to be_nil
    end

    it 'is 1 percent of the population rounded' do
      country = Country.new(population: 1_382_323_350)
      expect(country.target_signature_count).to eq(13_823_234)
    end
  end
end
