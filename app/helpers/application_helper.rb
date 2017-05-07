module ApplicationHelper
  LOCALES = { 'ar' => 'العربية',
              'ms' => 'bahasa melayu',
              'bn' => 'বাংলা',
              'bg' => 'български език',
              'cs' => 'čeština',
              'sr' => 'српски језик',
              'zh' => '中文',
              'de' => 'deutsch',
              'es' => 'español',
              'el' => 'ελληνικά',
              'en' => 'english',
              'fa' => 'فارسی',
              'fr' => 'français',
              'he' => 'עברית',
              'hi' => 'हिन्दी',
              'hr' => 'hrvatski jezik',
              'is' => 'íslenska',
              'it' => 'italiano',
              'ja' => '日本語',
              'ko' => '한국어',
              'lv' => 'latviešu valoda',
              'hu' => 'magyar',
              'nl' => 'nederlands',
              'pl' => 'polski',
              'pt' => 'português',
              'ro' => 'română',
              'ru' => 'pусский',
              'fi' => 'suomi',
              'sv' => 'svenska',
              'th' => 'ไทย',
              'vi' => 'tiếng việt',
              'tr' => 'türkçe' }

  def locales
    LOCALES
  end

  def current_language
    LOCALES[params[:locale]]
  end

  def petition_date
    year = 2017
    # See https://en.wikipedia.org/wiki/Date_and_time_notation_in_Thailand
    year += 543 if I18n.locale == :th
    "#{t('date.month_names')[5]} #{year}"
  end

  def rtl?
    [:he, :ar].include?(I18n.locale)
  end

  def text_direction
    rtl? ? 'rtl' : 'ltr'
  end
end
