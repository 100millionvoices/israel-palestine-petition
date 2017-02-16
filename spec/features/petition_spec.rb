require 'rails_helper'

feature 'Petition and signature count' do
  let!(:pending_signature)   { create(:pending_signature) }
  let!(:confirmed_signature) { create(:confirmed_signature) }

  scenario 'User is on home page' do
    visit '/'

    expect(page).to have_link('Sign petition', href: new_signature_path)
    within('.counter') do
      expect(page).to have_text '1 signatures'
    end
  end
end
