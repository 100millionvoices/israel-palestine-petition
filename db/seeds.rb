# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

COUNTRY_EQUIVALENTS = {
  'Brunei Darussalam' => 'Brunei',
  'Cape Verde' => 'Cabo Verde',
  "Korea, Democratic People's Republic of" => 'North Korea',
  'Korea, Republic of' => 'South Korea',
  "Lao People's Democratic Republic" => 'Laos',
  'Macao' => 'Macau',
  'Macedonia, Republic of' => 'Republic of Macedonia',
  'Micronesia, Federated States of' => 'Federated States of Micronesia',
  'Russian Federation' => 'Russia',
  'Viet Nam' => 'Vietnam',
  'Virgin Islands, British' => 'British Virgin Islands',
  'Virgin Islands, U.S.' => 'United States Virgin Islands'
}

def country_populations
  @country_populations ||= fetch_country_populations
end

def fetch_country_populations
  country_populations ||= []
  CSV.foreach(Rails.root.join('db/population.csv')) do |row|
    # why gsub? see http://stackoverflow.com/questions/20305966/why-does-strip-not-remove-the-leading-whitespace
    country_populations << [row[1].strip.gsub(/\A\p{Space}*/, ''), row[2]] if row[1]
  end
  country_populations
end

def find_country_population(name)
  country_population = country_populations.find { |country_population| name ==  country_population[0] }
  return country_population if country_population

  if COUNTRY_EQUIVALENTS.has_key?(name)
   country_populations.find { |country_population| COUNTRY_EQUIVALENTS[name] ==  country_population[0] }
  elsif name.index(',')
    abbreviated_name = name.match(/^[^,]*/)[0]
    country_populations.find { |country_population| abbreviated_name ==  country_population[0] }
  end
end

ISO3166::Country.translations.each do |country_code, name|
  country = Country.find_or_initialize_by(country_code: country_code)
  country.name = name
  country_population = find_country_population(name)
  if country_population
    country.population = country_population[1].gsub(',', '').to_i
  else
    puts "#{name} - country not found"
  end
  country.save!
end
