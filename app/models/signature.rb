class Signature < ApplicationRecord
  PENDING_STATE = 'pending'.freeze
  INVALID_STATE = 'invalid'.freeze
  CONFIRMED_STATE = 'confirmed'.freeze
  MAX_PLACES_FOR_COUNTRY = 25.freeze
  COUNTRY_CODES = ISO3166::Country.all.map(&:alpha2)

  ## scopes ##
  scope :confirmed, -> { where(state: CONFIRMED_STATE) }
  scope :pending, -> { where(state: PENDING_STATE) }

  ## validations ##
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, email: true, uniqueness: { case_sensitive: false }, on: :create
  validates :place, presence: true, length: { maximum: 50 }
  validates :country_code, presence: true, inclusion: { in: COUNTRY_CODES }
  validates :state, inclusion: { in: [PENDING_STATE, INVALID_STATE, CONFIRMED_STATE] }

  ## callbacks ##
  before_create :set_signing_token

  def confirm!
    return unless state == PENDING_STATE
    update_attributes!(state: CONFIRMED_STATE, signing_token: nil)

    cache_key = "confirmed_signatures_for_#{country_code}"
    unless Rails.cache.read(cache_key)
      country = Country.find_by(country_code: country_code)
      if country && !country.has_confirmed_signatures?
        country.update_attributes!(has_confirmed_signatures: true)
        Rails.cache.write(cache_key, 'true', expires_in: 1.hour)
      end
    end
  end

  def confirmed?
    state == CONFIRMED_STATE
  end

  def invalidate!
    update_columns(state: INVALID_STATE)
  end

  def self.count_for_country_code(country_code)
    confirmed.where(country_code: country_code).count if country_code.present?
  end

  def self.cached_count_for_country_code(country_code)
    if country_code == 'ALL'
      cached_count_total
    elsif COUNTRY_CODES.include?(country_code)
      Rails.cache.fetch("signature_count_#{country_code}") do
        count_for_country_code(country_code)
      end
    end
  end

  def self.cached_count_total
    Rails.cache.fetch('signature_count_all') { Signature.confirmed.count }
  end

  def self.count_by_place_for_country(country_code, limit)
    top_places = confirmed.where(country_code: country_code).group(:place)
                          .order(Arel.sql('count(*) DESC, UPPER(place) DESC'))
    top_places = top_places.limit(limit).count
    top_places.to_a.reverse.to_h
  end

  def self.cached_count_by_place_for_country(country_code, limit = MAX_PLACES_FOR_COUNTRY)
    Rails.cache.fetch("signature_count_by_place_#{country_code}_#{limit}") do
      count_by_place_for_country(country_code, limit)
    end
  end

  private

  def set_signing_token
    # taken from Devise.friendly_token
    rlength = (20 * 3) / 4
    self.signing_token = SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
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
