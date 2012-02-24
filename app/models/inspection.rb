class Inspection
  include MongoMapper::Document

  key :inspection_date, Date
  timestamps!

  validates_presence_of :inspection_date

  def self.type(subdomain)
    case subdomain
      when 'toronto'
        TorontoInspection
      when 'montreal'
        MontrealInspection
      when 'vancouver'
        VancouverInspection
      end
  end
end
