module PathHelper
  def url_for_locale(locale)
    url_for(action: action_name, controller: controller_name, locale: locale, only_path: false)
  end

  def signature_counts_update_page?
    controller_name == 'home' && action_name == 'index' ||
      controller_name == 'signatures' && action_name == 'index' ||
      controller_name == 'countries' && action_name == 'signatures'
  end
end
