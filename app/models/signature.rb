class Signature < ApplicationRecord
  PENDING_STATE = 'pending'.freeze
  INVALID_STATE = 'invalid'.freeze
  CONFIRMED_STATE = 'confirmed'.freeze
  COUNTRY_CODES = ISO3166::Country.all.map(&:alpha2)

  ## scopes ##
  scope :confirmed, -> { where(state: CONFIRMED_STATE) }
  scope :count_by_country_code, -> { confirmed.group(:country_code).count }

  ## validations ##
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, email: true, uniqueness: { case_sensitive: false }, on: :create
  validates :place, length: { maximum: 50 }
  validates :country_code, presence: true, inclusion: { in: COUNTRY_CODES }
  validates :state, inclusion: { in: [PENDING_STATE, INVALID_STATE, CONFIRMED_STATE] }

  ## callbacks ##
  before_create :set_signing_token

  def confirm!
    return unless state == PENDING_STATE
    update_attributes!(state: CONFIRMED_STATE, signing_token: nil)
  end

  def confirmed?
    state == CONFIRMED_STATE
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
