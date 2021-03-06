require 'rails_helper'

feature 'Confirm signature' do
  let(:pending_signature) { create(:pending_signature) }

  scenario 'User confirms signature' do
    visit confirm_signatures_path(token: pending_signature.signing_token, locale: :en)

    expect(page).to have_text 'Thank you for confirming your signature'
    expect(pending_signature.reload.confirmed?).to be_truthy
  end

  scenario 'User fails to confirm a non-existent signature' do
    visit confirm_signatures_path(token: 'no-token', locale: :en)

    expect(page).to have_text 'Your signature has already been confirmed'
  end
end
