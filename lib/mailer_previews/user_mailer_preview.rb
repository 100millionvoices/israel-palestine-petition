class UserMailerPreview < ActionMailer::Preview
  def confirm_signature
    signature = Signature.first || FactoryGirl.create(:signature)
    UserMailer.confirm_signature(signature)
  end
end
