FactoryGirl.define do
  factory :country do
    name_en 'Germany'
    country_code 'DE'
  end

  factory :germany, parent: :country

  factory :ghana, parent: :country do
    name_en 'Ghana'
    country_code 'GH'
  end
end
