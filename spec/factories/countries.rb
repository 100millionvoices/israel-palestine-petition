FactoryGirl.define do
  factory :country do
    name_de 'Deutschland'
    name_en 'Germany'
    country_code 'DE'
  end

  factory :germany, parent: :country

  factory :ghana, parent: :country do
    name_en 'Ghana'
    country_code 'GH'
  end

  factory :italy, parent: :country do
    name_en 'Italy'
    country_code 'IT'
  end

  factory :uk, parent: :country do
    name_en 'United Kingdom'
    country_code 'GB'
  end
end
