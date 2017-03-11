class UserMailerPreview < ActionMailer::Preview
  def confirm_signature
    signature = Signature.pending.first || FactoryGirl.create(:signature, email: "preview#{rand(10000)}@example.com")
    UserMailer.confirm_signature(signature, :en)
  end
end
