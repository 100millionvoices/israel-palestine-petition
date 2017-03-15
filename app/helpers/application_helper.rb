module ApplicationHelper
  LOCALES = { 'de' => 'deutsch', 'en' => 'english' }

  def locales
    LOCALES
  end

  def current_language
    LOCALES[params[:locale]]
  end
end
