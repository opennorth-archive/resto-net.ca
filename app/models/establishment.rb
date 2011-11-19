class Establishment
  include MongoMapper::Document

  key :source, String
  key :name, String
  key :latitude, Float
  key :longitude, Float
  key :street, String
  key :region, String
  key :locality, String
  key :country, String
  key :postal_code, String
  timestamps!
  
  validates_presence_of :source, :name

  before_validation :set_source

  scope :geocoded, where('latitude IS NOT NULL', 'longitude IS NOT NULL')

end
