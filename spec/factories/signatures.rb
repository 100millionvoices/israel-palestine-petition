FactoryGirl.define do
  factory :signature do
    sequence(:name)  { |n| "Jo Public #{n}" }
    sequence(:email) { |n| "jo#{n}@public.com" }
    country_code 'DE'
    state Signature::PENDING_STATE
  end

  factory :pending_signature, parent: :signature do
  end

  factory :pending_signature_gh, parent: :signature do
    country_code 'GH'
  end

  factory :confirmed_signature, parent: :signature do
    state             Signature::CONFIRMED_STATE
    after(:create) do |sig|
      sig.update_attributes! signing_token: nil
    end
  end

  factory :confirmed_signature_de, parent: :confirmed_signature

  factory :confirmed_signature_gh, parent: :confirmed_signature do
    country_code 'GH'
  end
end
