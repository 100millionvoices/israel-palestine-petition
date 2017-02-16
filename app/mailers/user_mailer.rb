class UserMailer < ApplicationMailer
  default from: '100MillionVoices<no-reply@100millionvoices.org>'

  def confirm_signature(signature)
    @signature = signature
    @url = confirm_signatures_url(token: signature.signing_token)
    mail(to: signature.email, subject: 'Confirm petition signature')
  end
end
