require 'rails_helper'

feature 'Signature counts' do
  let!(:pending_signature)   { create(:pending_signature) }
  let!(:confirmed_signature_de) { create(:confirmed_signature_de) }
  let!(:confirmed_signature_gh) { create_list(:confirmed_signature_gh, 2) }
  let(:ghana_geo_location) { double(country: double(iso_code: 'GH')) }

  scenario 'User country is unknown' do
    visit '/'

    expect(page).to have_link('Sign petition', href: new_signature_path)
    expect(page).to_not have_css('.country-counter-container')
    within('.counter-container') do
      expect(page).to have_text '3 total signatures'
    end
  end

  scenario 'User country is Ghana' do
    allow(GeoIpLookup).to receive(:fetch_location_from_ip).and_return(ghana_geo_location)
    visit '/'

    within('.country-counter-container') do
      expect(page).to have_text '2 signatures from Ghana'
    end
  end
end
