module Captcha
  CAPTCHA_URL = 'https://www.google.com/recaptcha/api/siteverify'.freeze

  def verify_captcha
    post_params = { secret: ENV['CAPTCHA_SECRET'], response: params['g-recaptcha-response'] }
    response = HTTParty.post(CAPTCHA_URL, body: post_params)
    hash_response = JSON.parse(response.body)
    if hash_response['success'] != true
      flash.now[:error] = I18n.t('errors.attributes.captcha.invalid')
      Raven.capture_message('Captcha error', level: :info,
                            extra: { signature: params[:signature].to_unsafe_h, captcha: hash_response })
    end
    hash_response['success'] == true
  end
end
