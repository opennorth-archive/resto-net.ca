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

    desc 'Import all data'
    task import: :environment do
      TorontoImporter.import
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
      MontrealImporter.download
    end

    desc 'Import all data'
    task import: :environment do
      MontrealImporter.import
    end

    desc 'Download XML and import all data'
    task update: :environment do
      MontrealImporter.download
      MontrealImporter.import
    end

    desc 'Find untranslated strings'
    task totranslate: :environment do
      %w(en fr).each do |language|
        puts "\n\n#{language}.establishment_type"
        strings = MontrealEstablishment.fields(:establishment_type).map(&:establishment_type).uniq
        puts strings.select{
          |x| I18n.t(x, locale: language, default: '').empty?
        }.sort

        puts "\n\n#{language}.description"
        strings = MontrealInspection.fields(:description).map(&:description).uniq
        puts strings.select{|x|
          I18n.t(:regulations, locale: language)[x.to_sym].blank?
        }.sort

        %w(long short).map(&:to_sym).each do |length|
          puts "\n\n#{language}.description.#{length}"
          puts strings.select{
            |x| I18n.t(:regulations, locale: language)[x.to_sym].present? && I18n.t(:regulations, locale: language)[x.to_sym][length].blank?
          }.sort
        end
      end
    end
  end
end
