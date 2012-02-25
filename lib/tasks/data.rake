namespace :data do
  require 'montreal_importer'
  require 'toronto_importer'
  require 'vancouver_importer'

  namespace :vancouver do
    desc "Import all infractions"
    task :import => :environment do
      VancouverImporter.import
    end
  end

  namespace :toronto do
    desc "Download and import new dinesafe data"
    task :update => :environment do
      TorontoImporter.download
      TorontoImporter.import
    end
  end

  namespace :montreal do
    desc "Download XML infraction data"
    task :download => :environment do
      (2007..Date.today.year).each do |year|
        MontrealImporter.new(year).download!
      end
    end

    desc "Import all infractions"
    task :import => :environment do
      (2007..Date.today.year).each do |year|
        MontrealImporter.new(year).scan
      end
    end

    desc "Update infractions"
    task :update => :environment do
      MontrealImporter.new(Date.today.year).scan(:remote)
    end
  end
end
