require 'rails_helper'

feature 'Signatures by country' do
  let!(:confirmed_signature_de) { create(:confirmed_signature_de) }
  let!(:confirmed_signature_gh) { create_list(:confirmed_signature_gh, 2) }

  scenario 'User views signature count breakdown by country' do
    visit signatures_path

    expect(page).to have_text 'Germany 1'
    expect(page).to have_text 'Ghana   2'
  end
end
