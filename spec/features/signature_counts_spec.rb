require 'rails_helper'

feature 'Signature counts API' do
  let!(:confirmed_signature_de)    { create(:confirmed_signature_de) }
  let!(:confirmed_signatures_gh)   { create_list(:confirmed_signature_gh, 2) }

  scenario 'View signature counts as json' do
    visit counts_signatures_path(locale: 'en', countries: 'DE,GH,NOTREAL,ALL')

    counts_hash = JSON.parse(page.body)
    expect(counts_hash).to eq('DE' => 1, 'GH' => 2, 'NOTREAL' => nil, 'ALL' => 3)
  end

  scenario 'Ajax update of signature counts on home page', :js do
    allow(GeoIpLookup).to receive(:fetch_location_from_ip).and_return(ghana_ip_location)
    visit home_path(locale: :en)

    expect(page).to have_text '2 signatures from Ghana'
    expect(page).to have_text '3 signatures in total'

    create(:confirmed_signature_gh)
    Rails.cache.clear

    expect(page).to have_text '3 signatures from Ghana'
    expect(page).to have_text '4 signatures in total'
  end

  scenario 'Ajax update of signature counts on signatures by country page', :js do
    create :ghana, has_confirmed_signatures: true
    create :germany, has_confirmed_signatures: true
    visit signatures_path(locale: :en)

    expect(page).to have_text 'Germany 1'
    expect(page).to have_text 'Ghana   2'

    create(:confirmed_signature_gh)
    Rails.cache.clear

    expect(page).to have_text 'Germany 1'
    expect(page).to have_text 'Ghana   3'
  end

  scenario 'Ajax update of signature count on country page', :js do
    create :ghana, has_confirmed_signatures: true
    visit country_path(locale: :en, country_code: 'gh')

    expect(page).to have_text 'The current signature count is 2'

    create(:confirmed_signature_gh)
    Rails.cache.clear

    expect(page).to have_text 'The current signature count is 3'
  end
end
