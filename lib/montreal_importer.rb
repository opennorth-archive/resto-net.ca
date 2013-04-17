# coding: utf-8
require 'fileutils'
require 'open-uri'
require 'unicode_utils/titlecase'

class MontrealImporter
  I18n.locale = :fr

  def self.import
    latest_judgment_date = MontrealInspection.first(order: 'judgment_date DESC').judgment_date rescue Date.new(2007, 1, 1)

    Nokogiri::XML(File.open(filepath).read, nil, 'iso-8859-1').xpath('//contrevenant').each do |xml|
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

  def self.download
    File.open(filepath, 'wb') do |f|
      f.write open(URI.encode('http://depot.ville.montreal.qc.ca/inspection-aliments-contrevenants/data.xml')).read
    end
  end

private

  def self.filepath
    File.join(Rails.root, 'data', 'data.xml')
  end

  # Names are originally in all caps.
  def self.get_name(xml, xpath)
    UnicodeUtils.titlecase(xml.at_xpath(xpath).text.gsub(/&amp;/, '&'), :fr).gsub("'S", "'s").strip
  end

  def self.get_date(xml, xpath)
    parts = xml.at_xpath(xpath).text.match /\A(\d+) (\p{L}+) (\d+)\z/
    Date.civil parts[3].to_i, I18n.t('date.month_names').index(parts[2]), parts[1].to_i
  end
end
