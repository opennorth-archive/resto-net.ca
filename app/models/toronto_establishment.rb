class TorontoEstablishment < Establishment
  
  key :dinesafe_id, Integer
  key :city, String
  key :address, String
  key :establishment_type, String
  key :minimum_inspections_per_year, Integer

  many :toronto_inspections

  before_create :geocode

  validates_presence_of :address, :city, :establishment_type, :dinesafe_id, :minimum_inspections_per_year

  validates_uniqueness_of :dinesafe_id

  validates_numericality_of :minimum_inspections_per_year, :only_integer => true, :greater_than => 0, :allow_blank => true

  def self.find_or_create_by_dinesafe_id(dinesafe_id, attributes = {})
    establishment = find_by_dinesafe_id( dinesafe_id )

    if establishment
      establishment
    else
      create!({
        :dinesafe_id => dinesafe_id
      }.merge(attributes))
    end
  end

  def short_address
    if geocoded? && street
      street
    else
      address
    end
  end

  def full_address
    if geocoded? && street && locality
      "#{street}, #{locality}"
    else
      "#{address}, #{city}"
    end
  end

  def geocode
    @@geocoder ||= Graticule.service(:google).new 'ABQIAAAACjg5EelPDHaItWLh83iDnxSTO_huFvQjFKOycbqUllPdGQkbfRRbpq18tH_FX8TyWWBPGwtlKiXNdA'

    begin
      location = @@geocoder.locate "#{address}, #{city}"
      %w(latitude longitude street_address region locality country postal_code).each do |attr|
        value = location.send(attr)
        self[attr] = value.is_a?(String) ? value.force_encoding('utf-8') : value
      end
      location
    rescue
      Rails.logger.warn "Geocoding error for '#{name}' @ '#{address}, #{city}': #{$!.message}"
      nil
    end
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

private

  def set_source
    self.source = 'Toronto'
  end

end
