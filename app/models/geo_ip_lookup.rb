class GeoIpLookup
  GEOIP_DB = MaxMindDB.new(ENV.fetch('GEOIP_DB_PATH')) if File.exist?(ENV.fetch('GEOIP_DB_PATH'))

  def self.fetch_location_from_ip(ip)
    return unless File.exist?(ENV.fetch('GEOIP_DB_PATH'))
    lookup = GEOIP_DB.lookup(ip)
    lookup.found? ? lookup : nil
  end
end
