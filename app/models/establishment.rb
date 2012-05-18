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

  validates_presence_of :name

  before_save :set_source

  scope :geocoded, where(:latitude.ne => nil, :longitude.ne => nil)

  def inspections
    raise NotImplementedError
  end

  def self.source
    raise NotImplementedError
  end

  def self.has_fines?
    column_names.include? 'fines_count'
  end

  def self.only_fines?
    false
  end

  # @see Inspection#short_name
  def short_name
    name.gsub(/\b(Boulangerie|Restaurant) | Inc\.\z/, '')
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

  def geocodeable?
    respond_to?(:address) && respond_to?(:city)
  end

  def short_address
    if geocodeable?
      address
    end
  end

  def full_address
    if geocodeable?
      "#{address}, #{city}"
    end
  end

  def geocode
    if geocodeable?
      begin
        location = Geocoder.locate "#{address}, #{city}"
        print '.'
        %w(latitude longitude street region locality country postal_code).each do |attribute|
          self[attribute] = location.send attribute
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

  # @todo use yellow pages api?
  def reviews
    term = name.gsub(/ Inc\.?/i, '') # @todo check for other cleanup, e.g. "the"
    response = Yelp.reviews term: term, location: full_address
    if response && response['name'] == term
      response['reviews']
    else
      []
    end
  rescue
    []
  end

private

  def set_source
    self.source = self.class.source
  end

end
