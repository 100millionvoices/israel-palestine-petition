class UserMailer < ApplicationMailer
  default from: '100MillionVoices<no-reply@100millionvoices.org>'

  def confirm_signature(signature, locale)
    @signature = signature
    @url = confirm_signatures_url(token: signature.signing_token, locale: locale)
    I18n.with_locale(locale) do
      mail(to: signature.email, subject: I18n.t('user_mailer.confirm_signature.subject'))
    end
  end
end
