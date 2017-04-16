module PathHelper
  def url_for_locale(locale)
    url_for(action: action_name, controller: controller_name, locale: locale, only_path: false)
  end

  def country_page?
    controller_name == 'countries' && action_name == 'show'
  end

  def sign_petition_page?
    controller_name == 'signatures' && %w(new create).include?(action_name)
  end

  def signature_counts_update_page?
    controller_name == 'home' && action_name == 'index' ||
      controller_name == 'signatures' && action_name == 'index'
  end
end
