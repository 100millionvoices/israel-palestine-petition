module SignaturesHelper
  FOREIGN_MINISTRY_NAME = 'Ministry of Foreign Affairs'.freeze
  # see https://en.wikipedia.org/wiki/Ministry_of_Foreign_Affairs
  FOREIGN_MINISTRY_NAMES = {
    'AU' => 'Department of Foreign Affairs and Trade',
    'GB' => 'Foreign and Commonwealth Office',
    'IE' => 'Department of Foreign Affairs and Trade',
    'US' => 'Department of State'
  }.freeze

  def signature_count_by_country(count_by_country_code)
    count_by_country = {}
    count_by_country_code.each do |k, v|
      count_by_country[country_from_country_code(k)] = [v, k.downcase]
    end
    count_by_country.sort
  end

  # change name of ministry if language is english and country is an exception
  def what_happens_if_target_is_met(country_code)
    if_target_is_met_text = t('signatures.what_happens_if_target_is_met')
    if I18n.locale == :en && FOREIGN_MINISTRY_NAMES.has_key?(country_code)
      if_target_is_met_text.gsub(FOREIGN_MINISTRY_NAME, FOREIGN_MINISTRY_NAMES[country_code])
    else
      if_target_is_met_text
    end
  end

  def country_from_country_code(country_code)
    ISO3166::Country.translations(I18n.locale)[country_code]
  end

  def error_messages_for_field(object, field_name, options = {})
    if errors = object && object.errors[field_name].presence
      content_tag :span, errors.first, { class: 'error-message' }.merge(options)
    end
  end

  def country_select_options
    options_for_select(ISO3166::Country.translations(I18n.locale).to_a.map(&:reverse).sort, @signature.country_code)
  end
end
