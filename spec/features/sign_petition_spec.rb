require 'rails_helper'

feature 'Sign petition' do
  let(:email) { 'jo@bloggs.com' }

  scenario 'User signs petition and receives an email' do
    stub_google_captcha_response(body: '{"success": true}')
    visit new_signature_path(locale: :en)
    fill_in 'Name', with: 'Jo Bloggs'

    click_button 'Sign it'
    expect(page).to have_text 'An email must be given'

    fill_in 'Email', with: email
    fill_in 'Place or city', with: 'Dartmouth'
    select 'United Kingdom', from: 'Country'
    click_button 'Sign it'

    expect(page).to have_text 'We have sent you an email.'
    signature = Signature.find_by(email: email)
    expect(signature.attributes).to include({ name: 'Jo Bloggs', place: 'Dartmouth', country_code: 'GB' }.stringify_keys)
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(ActionMailer::Base.deliveries.last.to).to eq [email]
  end

  scenario 'User fails captcha' do
    stub_google_captcha_response(body: '{"success": false, "error-codes": ["so bad"]}')
    visit new_signature_path(locale: :en)

    fill_in 'Name', with: 'Jo Bloggs'
    fill_in 'Email', with: email
    fill_in 'Place or city', with: 'Dartmouth'
    select 'United Kingdom', from: 'Country'
    click_button 'Sign it'

    expect(Signature.find_by(email: email)).to be_nil
    expect(page).to have_text 'The captcha has failed'
  end

  scenario 'Call to captcha times out' do
    expect(HTTParty).to receive(:post).and_raise(Net::HTTPGatewayTimeOut)
    visit new_signature_path(locale: :en)

    click_button 'Sign it'

    expect(page).to have_text 'The captcha has failed'
  end

  context 'disabled captcha' do
    after { ENV['CAPTCHA_DISABLED'] = 'false' }

    scenario 'No external call is made' do
      ENV['CAPTCHA_DISABLED'] = 'true'
      expect(HTTParty).to_not receive(:post)
      visit new_signature_path(locale: :en)

      click_button 'Sign it'

      expect(page).to have_text 'An email must be given'
    end
  end

  scenario 'Preselected city is Köln and country is Deutschland when locale is de' do
    allow(GeoIpLookup).to receive(:fetch_location_from_ip).and_return(cologne_ip_location)
    visit new_signature_path(locale: :de)

    expect(page).to have_field('Ort oder Stadt', with: 'Köln')
    expect(page).to have_select('Land', selected: 'Deutschland')
  end

  scenario 'Preselected city is Cologne and country is Germany when locale is en' do
    allow(GeoIpLookup).to receive(:fetch_location_from_ip).and_return(cologne_ip_location)
    visit new_signature_path(locale: :en)

    expect(page).to have_field('Place or city', with: 'Cologne')
    expect(page).to have_select('Country', selected: 'Germany')
  end

  scenario 'Preselected city is Köln and country is Germany when locale is en and the preferred languages are Italian and German' do
    allow_any_instance_of(HttpAcceptLanguage::Parser).to receive(:user_preferred_languages).and_return(['it-IT', 'de-DE'])
    allow(GeoIpLookup).to receive(:fetch_location_from_ip).and_return(cologne_ip_location)
    visit new_signature_path(locale: :en)

    expect(page).to have_field('Place or city', with: 'Köln')
    expect(page).to have_select('Country', selected: 'Germany')
  end
end
