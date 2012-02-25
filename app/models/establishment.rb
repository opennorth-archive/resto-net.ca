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

  def self.has_fines?
    column_names.include? 'fines_count'
  end

  def self.only_fines?
    %w(montreal).include? source
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

  def geocodeable?
    respond_to?(:address) && respond_to?(:city)
  end

  def short_address
    if geocoded? && street
      street
    elsif geocodeable?
      address
    end
  end

  def full_address
    if geocoded? && street && locality
      "#{street}, #{locality}"
    elsif geocodeable?
      "#{address}, #{city}"
    end
  end

  def geocode
    if geocodeable?
      begin
        location = Geocoder.locate "#{address}, #{city}"
        %w(latitude longitude street region locality country postal_code).each do |attribute|
          self[attribute] = location.send attribute
          #String === value ? value.force_encoding('utf-8') : value # @todo why do we need force_encoding?
          print '.'
        end
      rescue Graticule::CredentialsError # too many queries
        print '~'
        retry
      rescue
        Rails.logger.warn "Geocoding error for '#{name}' at '#{address}, #{city}': #{$!.message}"
        print '!'
      end
    end
  end

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

private

  def set_source
    self.source = self.class.source
  end

end
