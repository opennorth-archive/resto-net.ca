class Establishment
  include MongoMapper::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks

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

  scope :geocoded, where(:latitude.ne => nil, :longitude.ne => nil)

  Establishment.ensure_index :name

  def self.make_index
    tire.mapping do
      indexes :name, :type => 'string'
    end
  end

  def to_indexed_json
    self.to_json
  end

  def reviews
    term = name.gsub(/ Inc\.?/i, '')
    begin
      response = Yelp.reviews :term => term, :location => full_address
      if response && response['name'] == term
        response['reviews']
      else
        []
      end
    rescue
      []
    end
  end

end
