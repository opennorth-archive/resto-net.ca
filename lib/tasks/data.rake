namespace :data do
  require 'montreal_importer'
  require 'toronto_importer'
  require 'vancouver_importer'

  namespace :vancouver do
    desc "Import all infractions"
    task :import => :environment do
      I18n.locale = :en
      VancouverImporter.import
    end
  end

  namespace :toronto do
    desc "Download new dinesafe data"
    task :download => :environment do
      TorontoImporter.download
    end

    desc "Import all infractions"
    task :import => :environment do
      I18n.locale = :en
      TorontoImporter.import
    end
  end

  namespace :montreal do
    desc "Download XML infraction data"
    task :download => :environment do
      (2007..Date.today.year).each do |year|
        MontrealImporter.new(year).download
      end
    end

    desc "Import all infractions"
    task :import => :environment do
      I18n.locale = :fr
      (2007..Date.today.year).each do |year|
        MontrealImporter.new(year).scan
      end
    end

    desc "Update infractions"
    task :update => :environment do
      I18n.locale = :fr
      MontrealImporter.new(Date.today.year).scan(:remote)
    end
  end
end
