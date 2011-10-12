# coding: utf-8
require 'unicode_utils/titlecase'

class TorontoImporter 
  def self.log(msg)
    puts msg
  end

  def self.import
    log 'Opening dinesafe.xml'
    Nokogiri::XML(open(File.join(Rails.root, 'data', 'dinesafe.xml')).read, nil, 'utf-8').css('ROW').each do |row|
      if TorontoInspection.find_by_dinesafe_id row.at_css('ROW_ID').text.strip
        print '*'
      else
        establishment = TorontoEstablishment.find_or_create_by_dinesafe_id(row.at_css('ESTABLISHMENT_ID').text.strip,
          :name => get_name(row.at_css('ESTABLISHMENT_NAME').text),
          :address => row.at_css('ESTABLISHMENT_ADDRESS').text.strip,
          :establishment_type => row.at_css('ESTABLISHMENTTYPE').text.strip,
          :city => 'Toronto',
          :source => 'Toronto')
        inspection = establishment.toronto_inspections.build(
          :establishment_id             => establishment.id,
          :status                       => row.at_css('ESTABLISHMENT_STATUS').text.strip,
          :minimum_inspections_per_year => row.at_css('MINIMUM_INSPECTIONS_PERYEAR').text.strip,
          :description                  => row.at_css('INFRACTION_DETAILS').text.strip,
          :inspection_date              => row.at_css('INSPECTION_DATE').text.strip,
          :severity                     => row.at_css('SEVERITY').text.strip,
          :action                       => row.at_css('ACTION').text.strip,
          :court_outcome                => row.at_css('COURT_OUTCOME').text.strip,
          :amount                       => row.at_css('AMOUNT_FINED').text.strip,
          :dinesafe_id                  => row.at_css('ROW_ID').text.strip)
        inspection.save!
        print '.'
      end
    end
  end

private

  def self.get_name(name)
    UnicodeUtils.titlecase(name.gsub(/&amp;/, '&')).gsub(/'S/, "'s").strip
  end
end

