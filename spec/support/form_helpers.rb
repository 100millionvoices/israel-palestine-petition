def stub_google_captcha_response(body:)
  stub_request(:post, 'https://www.google.com/recaptcha/api/siteverify').
    with(body: "secret=#{ENV['CAPTCHA_SECRET']}&response=").to_return(body: body)
end
