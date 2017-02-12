module ApplicationHelper

  def facebook_sharing_url
    "https://www.facebook.com/sharer/sharer.php?#{share_params(u: home_url, ref: "responsive")}"
  end

  def twitter_sharing_url
    "https://twitter.com/intent/tweet?#{share_params(text: t('twitter_share'), url: home_url)}"
  end

  def email_share_body
    strip_tags(t('heading_html')) + "\n\n" + home_url
  end

  private

  def share_params(hash)
    hash.to_query.gsub('+', '%20')
  end
end
