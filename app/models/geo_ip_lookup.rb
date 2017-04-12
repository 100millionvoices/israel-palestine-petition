class GeoIpLookup
  GEOIP_DB = MaxMindDB.new(ENV.fetch('GEOIP_DB_PATH')) if File.exist?(ENV.fetch('GEOIP_DB_PATH'))
  GEOIP_LOCALES = { 'pt' => 'pt-BR', 'zh' => 'zh-CN' }.freeze

  def self.fetch_location_from_ip(ip)
    return unless defined?(GEOIP_DB)
    lookup = GEOIP_DB.lookup(ip)
    lookup.found? ? lookup : nil
  end

  def self.fetch_place_in_preferred_language(ip_location, language)
    locale = language.downcase.split('-', 2).first
    locale = GEOIP_LOCALES[locale] if GEOIP_LOCALES.has_key?(locale)
    ip_location.city&.name(locale)
  end
end
