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

  ensure_index :source
  ensure_index :name

  # @todo remove if not using elasticsearch
  mapping do
    indexes :id, index: :not_analyzed
    indexes :source, index: :not_analyzed
    indexes :name, analyzer: 'snowball'
    # @todo add any other fields for display
    # @todo read about analyzers, boost
  end

  validates_presence_of :source, :name

  before_validation :set_source

  scope :geocoded, where(:latitude.ne => nil, :longitude.ne => nil)

  # @todo remove if not using elasticsearch
  def to_indexed_json
    self.to_json
  end

  # @todo use yellow pages api?
  def reviews
    term = name.gsub(/ Inc\.?/i, '') # @todo check for other cleanup, e.g. "the"
    begin
      response = Yelp.reviews term: term, location: full_address
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
