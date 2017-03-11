module SharingHelper
  def facebook_sharing_url
    "https://www.facebook.com/sharer/sharer.php?#{share_params(u: home_url, ref: "responsive")}"
  end

  def twitter_sharing_url
    "https://twitter.com/intent/tweet?#{share_params(text: t('sharing.twitter_share'), url: home_url)}"
  end

  def email_share_body
    sharing_text
  end

  def whatsapp_sharing_url
    'whatsapp://send?' + share_params(text: sharing_text)
  end

  private

  def sharing_text
     "#{I18n.t('sharing.share_text')}\n\n#{home_url}"
  end

  def share_params(hash)
    hash.to_query.gsub('+', '%20')
  end
end
