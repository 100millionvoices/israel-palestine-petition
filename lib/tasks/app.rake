namespace :app do

  desc 'Add confirmed signatures so that dynamic signature count updating is observable'
  task create_signatures: :environment do
    loop do
      sleep 1
      signature = Signature.confirmed.order('random()').first
      unique = SecureRandom.urlsafe_base64((20 * 3) / 4).tr('lIO0', 'sxyz')
      place = if signature.country_code == 'DE'
                GERMAN_CITIES[rand(0..49)]
              else
                signature.place
              end
      Signature.confirmed.create!(country_code: signature.country_code, place: place,
                                  name: 'Jay Z', email: "unique-#{unique}@example.com")
    end
  end
end

# from https://en.wikipedia.org/wiki/List_of_cities_in_Germany_by_population
GERMAN_CITIES = [
  'Berlin',
  'Hamburg',
  'Munich',
  'Cologne',
  'Frankfurt',
  'Essen',
  'Dortmund',
  'Stuttgart',
  'Düsseldorf',
  'Bremen',
  'Hanover',
  'Duisburg',
  'Nuremberg',
  'Leipzig',
  'Dresden',
  'Bochum',
  'Wuppertal',
  'Bielefeld',
  'Bonn',
  'Mannheim',
  'Karlsruhe',
  'Gelsenkirchen',
  'Wiesbaden',
  'Münster',
  'Mönchengladbach',
  'Chemnitz',
  'Augsburg',
  'Braunschweig',
  'Aachen',
  'Krefeld',
  'Halle',
  'Kiel',
  'Magdeburg',
  'Oberhausen',
  'Lübeck',
  'Freiburg',
  'Hagen',
  'Erfurt',
  'Kassel',
  'Rostock',
  'Mainz',
  'Hamm',
  'Saarbrücken',
  'Herne',
  'Mülheim an der Ruhr',
  'Solingen',
  'Osnabrück',
  'Ludwigshafen am Rhein',
  'Leverkusen',
  'Oldenburg']
