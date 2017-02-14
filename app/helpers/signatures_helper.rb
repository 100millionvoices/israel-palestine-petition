module SignaturesHelper
  def error_messages_for_field(object, field_name, options = {})
    if errors = object && object.errors[field_name].presence
      content_tag :span, errors.first, { class: 'error-message' }.merge(options)
    end
  end

  def country_select_options
    options_for_select(ISO3166::Country.translations.to_a.map(&:reverse), @signature.country_code)
  end
end
