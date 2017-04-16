require 'rails_helper'

describe Signature do
  it 'has a valid factory' do
    expect(build(:signature)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }

    it { should validate_presence_of(:email) }
    it 'email cannot include a plus sign' do
      expect(build(:signature, email: 'john+1@example.com')).to be_invalid
    end

    it { should validate_presence_of(:place) }
    it { should validate_length_of(:place).is_at_most(50) }

    it { should validate_presence_of(:country_code) }
    it 'country code must be recognised' do
      signature = build(:signature, country_code: 'XX')
      expect(signature).to be_invalid
    end

    it do
      create :signature
      should validate_uniqueness_of(:email).case_insensitive
    end

    # TODO: 'https://github.com/thoughtbot/shoulda-matchers/issues/904'
    # it { should validate_inclusion_of('state').in_array(['pending', 'invalid', 'confirmed']) }
  end

  describe 'call backs' do
    it 'set signing_token on create' do
      signature = create(:signature)
      expect(signature.signing_token).to_not be_nil
    end
  end

  describe 'scopes' do
    it 'confirmed' do
      expect(Signature.confirmed.where_values_hash).to eq('state' => 'confirmed')
    end
  end

  describe '#confirm!' do
    let(:signature) { create(:pending_signature, country_code: 'GH') }

    it 'sets the state to confirmed' do
      signature.confirm!
      expect(signature.state).to eq(Signature::CONFIRMED_STATE)
      expect(signature.signing_token).to be_nil
    end

    it 'sets the associated country to confirmed_signatures true' do
      country = Country.create!(name_en: 'Ghana', country_code: 'GH')
      signature.confirm!
      expect(country.reload).to have_confirmed_signatures
    end
  end

  describe '#confirmed?' do
    it 'true' do
      signature = create(:confirmed_signature)
      expect(signature).to be_confirmed
    end

    it 'false' do
      signature = create(:pending_signature)
      expect(signature).to_not be_confirmed
    end
  end

  describe '#invalidate!' do
    let(:signature) { create(:pending_signature, country_code: 'GH') }

    it 'sets the state to invalid' do
      signature.invalidate!
      expect(signature.state).to eq(Signature::INVALID_STATE)
    end
  end

  describe '.count_for_country_code' do
    it 'returns a signature count for a specific country code' do
      create :pending_signature
      create :confirmed_signature_de
      create_list :confirmed_signature_gh, 2

      expect(Signature.count_for_country_code('GH')).to eq(2)
    end

    it 'returns nil for an empty country code' do
      expect(Signature.count_for_country_code('')).to be_nil
    end
  end

  describe '.count_by_place_for_country' do
    it 'returns a place and count array sorted by count' do
      create :pending_signature_gh
      create :confirmed_signature_de
      create_list :confirmed_signature_gh, 3, place: 'Accra'
      create_list :confirmed_signature_gh, 1, place: 'Kokrobite'
      create_list :confirmed_signature_gh, 1, place: 'Koforidua'
      create_list :confirmed_signature_gh, 1, place: 'koforidua'

      counts_by_place = Signature.count_by_place_for_country('GH').to_a
      expect(counts_by_place).to eq([['koforidua', 1], ['Koforidua', 1], ['Kokrobite', 1], ['Accra', 3]])
    end
  end
end
