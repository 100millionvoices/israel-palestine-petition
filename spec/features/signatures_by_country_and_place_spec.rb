require 'rails_helper'

feature 'Signatures by country and place' do
  let!(:germany)                       { create :ghana, population: 100_000, has_confirmed_signatures: true }
  let!(:ghana)                         { create :germany, has_confirmed_signatures: true }
  let!(:confirmed_signature_de)        { create(:confirmed_signature_de) }
  let!(:confirmed_signatures_gh_accra) { create_list(:confirmed_signature_gh, 2, place: 'Accra') }
  let!(:confirmed_signature_gh)        { create(:confirmed_signature_gh, place: 'Bolgatanga') }

  scenario 'User views signature count breakdown by country and then by place' do
    visit signatures_path(locale: :en)

    expect(page).to have_text 'Germany 1'
    expect(page).to have_text 'Ghana   3'

    click_link 'Ghana'
    expect(page).to have_text 'Signatures from Ghana'
    expect(page).to have_text 'The current signature count is 3'
    expect(page).to have_text 'The target is 1,000'
    expect(page).to have_text 'Bolgatanga 1'
    expect(page).to have_text 'Accra 2'
  end

  scenario 'Signature counts for country as json' do
    visit signature_counts_country_path(locale: :en, country_code: 'gh')

    counts_hash = JSON.parse(page.body)
    expect(counts_hash).to eq('total' => 3, 'places' => { 'Bolgatanga' => 1, 'Accra' => 2 })
  end

  scenario 'Ajax update of place signature counts and added place on country page', :js do
    visit country_path(locale: :en, country_code: 'gh')

    expect(page).to have_text 'Bolgatanga 1'
    expect(page).to have_text 'Accra 2'

    create(:confirmed_signature_gh, place: 'Accra')
    create(:confirmed_signature_gh, place: 'Wa')
    Rails.cache.clear

    expect(page).to have_text 'Bolgatanga 1'
    expect(page).to have_text 'Wa 1'
    expect(page).to have_text 'Accra 3'
  end

  scenario 'Ajax place removal on country page', :js do
    visit country_path(locale: :en, country_code: 'gh')

    expect(page).to have_text 'Bolgatanga 1'
    expect(page).to have_text 'Accra 2'

    confirmed_signature_gh.invalidate!
    Rails.cache.clear

    expect(page).to have_text 'Accra 2'
    expect(page).to_not have_text 'Bolgatanga'
  end
end
