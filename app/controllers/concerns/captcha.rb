module Captcha
  extend ActiveSupport::Concern
  CAPTCHA_URL = 'https://www.google.com/recaptcha/api/siteverify'.freeze

  included do
    helper_method :captcha_disabled?
  end

  def captcha_disabled?
    ENV['CAPTCHA_DISABLED'] == 'true'
  end

  def verify_captcha
    post_params = { secret: ENV['CAPTCHA_SECRET'], response: params['g-recaptcha-response'] }
    response = HTTParty.post(CAPTCHA_URL, body: post_params)
    hash_response = JSON.parse(response.body)

    if hash_response['success'] != true
      handle_error('Captcha error', :info, signature: params[:signature].to_unsafe_h, captcha: hash_response)
    end
    hash_response['success'] == true

  rescue StandardError => e
    handle_error(e, :error)
    false
  end

  def handle_error(error, level, options = {})
    flash.now[:error] = I18n.t('errors.attributes.captcha.invalid')
    Raven.capture_message(error, level: level, extra: options)
  end
end
