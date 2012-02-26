namespace :data do
  namespace :vancouver do
    require 'vancouver_importer'

    desc 'Clear data'
    task clear: :environment do
      VancouverEstablishment.destroy_all
      VancouverInspection.destroy_all
    end

    desc 'Import all data'
    task import: :environment do
      VancouverImporter.import
    end
  end

  namespace :toronto do
    require 'toronto_importer'

    desc 'Clear data'
    task clear: :environment do
      TorontoEstablishment.destroy_all
      TorontoInspection.destroy_all
    end

    desc 'Download XML'
    task download: :environment do
      TorontoImporter.download
    end

    desc 'Download XML and import all data'
    task update: :environment do
      TorontoImporter.download
      TorontoImporter.import
    end
  end

  namespace :montreal do
    require 'montreal_importer'

    desc 'Clear data'
    task clear: :environment do
      MontrealEstablishment.destroy_all
      MontrealInspection.destroy_all
    end

    desc 'Download XML'
    task download: :environment do
      (2007..Date.today.year).each do |year|
        MontrealImporter.new(year).download!
      end
    end

    desc 'Import all data'
    task import: :environment do
      (2007..Date.today.year).each do |year|
        MontrealImporter.new(year).scan
      end
    end

    desc 'Update data'
    task update: :environment do
      MontrealImporter.new(Date.today.year).scan(:remote)
    end
  end
end
