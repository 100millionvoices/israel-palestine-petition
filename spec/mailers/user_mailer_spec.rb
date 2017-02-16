require 'rails_helper'

describe UserMailer do
  it 'send a signature confirmation email' do
    signature = create(:signature)
    email = UserMailer.confirm_signature(signature)

    email.deliver_now
    expect(email.from).to eq(['no-reply@100millionvoices.org'])
    expect(email.to).to eq([signature.email])
    expect(email.subject).to eq('Confirm petition signature')
  end
end
