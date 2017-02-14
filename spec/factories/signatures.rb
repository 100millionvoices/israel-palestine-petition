FactoryGirl.define do
  factory :signature do
    sequence(:name)  {|n| "Jo Public #{n}" }
    sequence(:email) {|n| "jo#{n}@public.com" }
    country_code     'DE'
    state             Signature::PENDING_STATE
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
