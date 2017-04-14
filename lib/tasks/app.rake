namespace :app do

  desc 'Add confirmed signatures so that dynamic signature count updating is observable'
  task create_signatures: :environment do
    loop do
      sleep 1
      signature = Signature.confirmed.order('random()').first
      unique = SecureRandom.urlsafe_base64((20 * 3) / 4).tr('lIO0', 'sxyz')
      Signature.confirmed.create!(country_code: signature.country_code, place: signature.place,
                                  name: 'Jay Z', email: "unique-#{unique}@example.com")
    end
  end
end
