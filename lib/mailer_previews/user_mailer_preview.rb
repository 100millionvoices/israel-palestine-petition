class UserMailerPreview < ActionMailer::Preview
  I18n.available_locales.each do |locale|
    define_method "confirm_signature_#{locale}" do
      signature = FactoryGirl.create(:signature, email: "preview#{rand(10000)}@example.com")
      UserMailer.confirm_signature(signature, locale)
    end
  end
end
