class Country < ApplicationRecord
  TARGET_AS_RATIO_OF_POPULATION = 0.01.freeze

  ## validations ##
  validates :name, :country_code, presence: true

  def signature_count
    @signature_count ||= Signature.count_for_country_code(country_code)
  end

  def target_reached?
    signature_count >= target_signature_count if population
  end

  def target_signature_count
    (population * TARGET_AS_RATIO_OF_POPULATION).round if population
  end
end

# == Schema Information
#
# Table name: countries
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  country_code  :string           not null
#  population    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
