require 'rails_helper'

feature 'Sign petition' do

  scenario 'User signs petition' do
    visit '/signatures/new'
    fill_in 'signature_name', with: 'Jo Bloggs'

    click_button 'Sign it'
    expect(page).to have_text 'An email must be given'

    fill_in 'signature_email', with: 'jo@bloggs.com'
    fill_in 'signature_place', with: 'Dartmouth'
    select 'United Kingdom', from: 'signature_country_code'
    click_button 'Sign it'

    expect(page).to have_text 'We have sent you an email.'
    signature = Signature.find_by(email: 'jo@bloggs.com')
    expect(signature.attributes).to include({ name: 'Jo Bloggs', place: 'Dartmouth', country_code: 'GB' }.stringify_keys)
  end
end
