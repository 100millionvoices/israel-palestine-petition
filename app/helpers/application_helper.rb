module ApplicationHelper
  LOCALES = { 'de' => 'Deutsch', 'en' => 'English' }

  def locales
    LOCALES
  end

  def current_language
    LOCALES[params[:locale]]
  end
end
