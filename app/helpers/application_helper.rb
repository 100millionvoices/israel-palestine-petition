module ApplicationHelper
  LOCALES = { 'de' => 'deutsch', 'en' => 'english' }

  def locales
    LOCALES
  end

  def current_language
    LOCALES[params[:locale]]
  end

  def petition_date
    "#{t('date.month_names')[5]} 2017"
  end
end
