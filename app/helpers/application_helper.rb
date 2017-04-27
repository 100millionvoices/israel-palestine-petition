module ApplicationHelper
  LOCALES = { 'ar' => 'العربية',
              'de' => 'deutsch',
              'cs' => 'čeština',
              'en' => 'english',
              'es' => 'español',
              'he' => 'עברית',
              'nl' => 'nederlands' }

  def locales
    LOCALES
  end

  def current_language
    LOCALES[params[:locale]]
  end

  def petition_date
    "#{t('date.month_names')[5]} 2017"
  end

  def rtl?
    [:he, :ar].include?(I18n.locale)
  end

  def text_direction
    rtl? ? 'rtl' : 'ltr'
  end
end
