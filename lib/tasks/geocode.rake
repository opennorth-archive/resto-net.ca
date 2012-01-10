task :geocode => :environment do
  TorontoEstablishment.all.each { |te| te.geocode }
  MontrealEstablishment.all.each { |me| me.geocode }
end
