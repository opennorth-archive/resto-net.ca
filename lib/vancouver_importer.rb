# coding: utf-8
require 'unicode_utils/titlecase'

class VancouverImporter 
  def self.log(msg)
    puts msg
  end

  def self.import
    Dir.chdir(File.join(Rails.root, '/data/vancouver/restos'))
    Dir.glob('*.html').each do |file|
      html = Nokogiri::HTML(open(file).read, nil, 'utf-8')
      table = html.xpath('//table[@class="columnar"]').first
        establishment_attributes = {
          :name => get_name(html.xpath('//h3[@class="bottom-border"]').first.text.strip),
          :address => get_address(html.xpath('//div[@id="address"]').text.strip),
          :city => 'Vancouver',
          :owner_name => table.children.first.at_css('td').text.strip,
          :operator_name => table.children[1].at_css('td').text.strip,
          :capacity => table.children[2].xpath('td').first.text.strip,
          :establishment_type => table.children[2].xpath('td').last.text.strip,
          :vch_id => File.basename(file, '.html'),
          :source => 'Vancouver',
        }
        establishment = VancouverEstablishment.create(establishment_attributes)
          print '*'
    end
    Dir.chdir(File.join(Rails.root, '/data/vancouver/inspections'))
    Dir.glob('*.html').each do |file|
      html = Nokogiri::HTML(open(file).read, nil, 'utf-8')
      details = html.xpath('//table[@class="tabular"]//tr')
      table = html.xpath('//table[@class="columnar"]')[1]
      if html.xpath('//h3[@class="bottom-border"]').first.nil?
        next
      end
      inspection_attributes = {
        :vancouver_establishment => VancouverEstablishment.find_by_name(get_name(html.xpath('//h3[@class="bottom-border"]').first.text.strip)),
        :inspection_date => table.children.first.at_css('td').text.strip,
        :inspector => table.children[1].at_css('td').text.strip,
        :follow_up_required => table.children[2].at_css('td').text.strip,
        :reason => table.children[3].at_css('td').text.strip,
        :action => table.children[4].at_css('td').text.strip,
        :referrals => table.children[5].at_css('td').text.strip,
        :general_comments => table.children[6].at_css('td').text.strip,
        :closing_comments => table.children[5].at_css('td').text.strip
        }
        inspection = VancouverInspection.create(inspection_attributes)
        details.each do |row|
          if row.nil? || row.children.empty? || row.children[1].nil?
            next
          end
          print '^'
          inspection_detail = inspection.vancouver_inspection_details.build(
          :vancouver_inspection => inspection,
          :observation => row.children[1].xpath('//td//h4').text.strip,
          :description => row.children[1].xpath('//td//p').map{|x| x.to_s}.join(' '),
          :num_new_observations => row.children[2].at_css('td'),
          :num_resolved_observations => row.children[3].at_css('td')
        )
          print '.'
        end
    end
  end

private

  def self.get_name(name)
    UnicodeUtils.titlecase(name.gsub(/&amp;/, '&')).gsub(/'S/, "'s").strip
  end

  def self.get_address(addr)
    addr.split.join ' '
  end
end
