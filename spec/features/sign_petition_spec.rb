require 'rails_helper'

feature 'Sign petition' do
    let(:email) { 'jo@bloggs.com' }

  scenario 'User signs petition and receives an email' do
    visit '/signatures/new'
    fill_in 'signature_name', with: 'Jo Bloggs'

    click_button 'Sign it'
    expect(page).to have_text 'An email must be given'

    fill_in 'signature_email', with: email
    fill_in 'signature_place', with: 'Dartmouth'
    select 'United Kingdom', from: 'signature_country_code'
    click_button 'Sign it'

    expect(page).to have_text 'We have sent you an email.'
    signature = Signature.find_by(email: email)
    expect(signature.attributes).to include({ name: 'Jo Bloggs', place: 'Dartmouth', country_code: 'GB' }.stringify_keys)
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(ActionMailer::Base.deliveries.last.to).to eq [email]
  end
end
