class Country < ApplicationRecord
  TARGET_AS_RATIO_OF_POPULATION = 0.01.freeze

  ## scopes ##
  scope :with_confirmed_signatures, -> { where(has_confirmed_signatures: true) }

  ## validations ##
  validates :name_en, :country_code, presence: true

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
#  id                       :integer          not null, primary key
#  name_en                  :string           not null
#  country_code             :string           not null
#  population               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  has_confirmed_signatures :boolean          default(FALSE)
#  name_ar                  :string
#  name_ms                  :string
#  name_bn                  :string
#  name_bg                  :string
#  name_cs                  :string
#  name_sr                  :string
#  name_zh                  :string
#  name_de                  :string
#  name_es                  :string
#  name_el                  :string
#  name_fa                  :string
#  name_fr                  :string
#  name_he                  :string
#  name_hi                  :string
#  name_hr                  :string
#  name_is                  :string
#  name_it                  :string
#  name_ja                  :string
#  name_ko                  :string
#  name_lv                  :string
#  name_hu                  :string
#  name_nl                  :string
#  name_pl                  :string
#  name_pt                  :string
#  name_ro                  :string
#  name_ru                  :string
#  name_fi                  :string
#  name_sv                  :string
#  name_th                  :string
#  name_vi                  :string
#  name_tr                  :string
#
