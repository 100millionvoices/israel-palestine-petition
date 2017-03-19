require 'rails_helper'

feature 'Signatures by country and place' do
  let!(:confirmed_signature_de) { create(:confirmed_signature_de) }
  let!(:confirmed_signatures_gh_accra) { create_list(:confirmed_signature_gh, 2, place: 'Accra') }
  let!(:confirmed_signatures_gh)       { create_list(:confirmed_signature_gh, 1, place: 'Bolgatanga') }
  let!(:ghana)                         { Country.create(name: 'Ghana', country_code: 'GH', population: 100_000) }

  scenario 'User views signature count breakdown by country and then by place' do
    visit signatures_path(locale: :en)

    expect(page).to have_text 'Germany 1'
    expect(page).to have_text 'Ghana   3'

    click_link 'Ghana'
    expect(page).to have_text 'Signatures from Ghana'
    expect(page).to have_text 'The current signature count is 3.'
    expect(page).to have_text 'The target is 1,000'
    expect(page).to have_text 'Bolgatanga 1'
    expect(page).to have_text 'Accra 2'
  end
end
