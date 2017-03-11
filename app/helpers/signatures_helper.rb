module SignaturesHelper
  def signature_count_by_country(count_by_country_code)
    count_by_country = {}
    count_by_country_code.each do |k, v|
      count_by_country[country_from_country_code(k)] = v
    end
    count_by_country.sort
  end

  def country_from_country_code(country_code)
    ISO3166::Country.translations[country_code]
  end

  def error_messages_for_field(object, field_name, options = {})
    if errors = object && object.errors[field_name].presence
      content_tag :span, errors.first, { class: 'error-message' }.merge(options)
    end
  end

  def country_select_options
    options_for_select(ISO3166::Country.translations.to_a.map(&:reverse), @signature.country_code)
  end
end
