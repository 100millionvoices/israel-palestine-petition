require 'rails_helper'

describe Signature do
  it 'has a valid factory' do
    expect(build(:signature)).to be_valid
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }

    it { should validate_presence_of(:email) }
    it 'email cannot include a plus sign' do
      expect(build(:signature, email: 'john+1@example.com')).to be_invalid
    end

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

    # TODO 'https://github.com/thoughtbot/shoulda-matchers/issues/904'
    # it { should validate_inclusion_of('state').in_array(['pending', 'invalid', 'confirmed']) }
  end

  context 'call backs' do
    it 'set signing_token on create' do
      signature = create(:signature)
      expect(signature.signing_token).to_not be_nil
    end
  end
end

# == Schema Information
#
# Table name: signatures
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  email         :string           not null
#  place         :string
#  country_code  :string           not null
#  state         :string           default("pending"), not null
#  signing_token :string
#  ip_address    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
