module PathHelper
  def url_for_locale(locale)
    url_for(action: action_name, controller: controller_name, locale: locale, only_path: false)
  end
end
