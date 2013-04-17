# coding: utf-8
require 'unicode_utils/titlecase'

class TorontoImporter 
  def self.log(msg)
    puts msg
  end

  def self.import
    self.download
    log 'Opening dinesafe.xml'
    Nokogiri::XML(File.open(filepath).read, nil, 'utf-8').css('ROW').each do |row|
      establishment_attributes = {
        :name => get_name(row.at_css('ESTABLISHMENT_NAME').text),
        :address => row.at_css('ESTABLISHMENT_ADDRESS').text.strip,
        :establishment_type => row.at_css('ESTABLISHMENTTYPE').text.strip,
        :city => 'Toronto',
        :minimum_inspections_per_year => row.at_css('MINIMUM_INSPECTIONS_PERYEAR').text.strip.to_i,
      }
      inspection = TorontoInspection.where('toronto_inspection_details.dinesafe_id' => row.at_css('ROW_ID').text.strip.to_i).first
      if inspection
        print '*'
      else
        establishment = TorontoEstablishment.find_or_create_by_dinesafe_id(row.at_css('ESTABLISHMENT_ID').text.strip.to_i, establishment_attributes)
        inspection = TorontoInspection.find_or_create_by_dinesafe_id( 
          row.at_css('INSPECTION_ID').text.strip.to_i,
          {:inspection_date              => row.at_css('INSPECTION_DATE').text.strip,
           :toronto_establishment     => establishment, 
          })
        inspection_detail = inspection.toronto_inspection_details.build(
          :toronto_inspection           => inspection,
          :description                  => row.at_css('INFRACTION_DETAILS').text.strip,
          :severity                     => row.at_css('SEVERITY').text.strip,
          :status => row.at_css('ESTABLISHMENT_STATUS').text.strip,
          :action                       => row.at_css('ACTION').text.strip,
          :court_outcome                => row.at_css('COURT_OUTCOME').text.strip,
          :amount                       => row.at_css('AMOUNT_FINED').text.strip,
          :dinesafe_id                  => row.at_css('ROW_ID').text.strip)
        inspection_detail.save!
        print '.'
      end
    end
  end

  def self.download
     File.open(File.join(Rails.root, 'data', 'dinesafe.zip'), 'wb') do |f|
       f.write open(URI.encode('http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip')).read
     end
     unzip File.join(Rails.root, 'data', 'dinesafe.zip'), File.join(Rails.root, 'data')
  end

private

  def self.unzip(filename, dest)
    system "unzip -o #{filename} -d #{dest}"
  end

  def self.nzip(file)
    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
        zip_file.extract(f, filepath) unless File.exist?(filepath)
      }
    }
  end

  def self.filepath
    File.join(Rails.root, 'data', 'dinesafe.xml')
  end

  def self.get_name(name)
    UnicodeUtils.titlecase(name.gsub(/&amp;/, '&')).gsub(/'S/, "'s").strip
  end
end

