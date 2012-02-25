# coding: utf-8
require 'fileutils'
require 'open-uri'
require 'unicode_utils/titlecase'

class MontrealImporter
  def initialize(year = nil)
    I18n.locale = :fr
    @year = year || Date.today.year
  end

  def scan(source = nil)
    latest_judgment_date = MontrealInspection.first(order: 'judgment_date DESC').judgment_date rescue Date.new(2007, 1, 1)

    puts "Importing infractions for #{@year}"
    Nokogiri::XML(content(source), nil, 'utf-8').xpath('//contrevenant').each do |xml|
      establishment = MontrealEstablishment.find_or_create_by_name_and_address_and_city(
        get_name(xml, 'etablissement'),
        xml.at_xpath('adresse').text.strip,
        xml.at_xpath('ville').text.strip,
        establishment_type: xml.at_xpath('categorie').text.strip, 
        owner_name: get_name(xml, 'proprietaire'))
      inspection = establishment.montreal_inspections.build(
        description: xml.at_xpath('description').text.strip,
        inspection_date: get_date(xml, 'date_infraction'),
        judgment_date: get_date(xml, 'date_jugement'),
        amount: xml.at_xpath('montant').text.strip.to_i)
      if inspection.judgment_date > latest_judgment_date
        inspection.save!
        print '.'
      else
        print '*'
      end
    end
    puts 'Done'
  end

  def download
    if downloaded?
      puts "Skipping #{filename}"
    else
      download!
    end
  end

  def download!
    FileUtils.mkdir_p File.join(Rails.root, 'data')
    puts "Downloading #{filename}"
    File.open filename, 'wb' do |f|
      f.write content(:remote)
    end
  end

private

  def filename
    File.join Rails.root, 'data', "#{@year}.xml"
  end

  def downloaded?
    File.exists? filename
  end

  def content(source = nil)
    if source.nil? && downloaded? || source == :local
      File.read filename
    else
      open("http://ville.montreal.qc.ca/pls/portal/portalcon.contrevenants_recherche?p_mot_recherche=,tous,#{@year}").read
    end
  end

  # Names are originally in all caps.
  def get_name(xml, xpath)
    UnicodeUtils.titlecase(xml.at_xpath(xpath).text.gsub(/&amp;/, '&'), :fr).gsub("'S", "'s").strip
  end

  def get_date(xml, xpath)
    parts = xml.at_xpath(xpath).text.match /\A(\d+) (\p{L}+) (\d+)\z/
    Date.civil parts[3].to_i, I18n.t('date.month_names').index(parts[2]), parts[1].to_i
  end
end
