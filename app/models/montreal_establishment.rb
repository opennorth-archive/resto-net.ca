class MontrealEstablishment < Establishment
  
  key :address, String
  key :city, String
  key :establishment_type, String
  key :owner_name, String
  key :name_fingerprint, String
  key :address_fingerprint, String
  key :city_fingerprint, String

  many :montreal_inspections

  validates_presence_of :address, :city, :establishment_type, :owner_name

  before_create :geocode
  before_save :fingerprint

  def self.find_or_create_by_name_and_address_and_city(name, address, city, attributes = {})
    establishment = find_by_name_fingerprint_and_address_fingerprint_and_city_fingerprint( name.fingerprint, address.fingerprint, city.fingerprint )

    if establishment
      establishment
    else
      create!({
        :name => name,
        :address => address,
        :city => city,
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
      %w(latitude longitude street region locality country postal_code).each do |attr|
        value = location.send(attr)
        self[attr] = value.is_a?(String) ? value.force_encoding('utf-8') : value
        print '*'
      end
      location
    rescue
      Rails.logger.warn "Geocoding error for '#{name}' @ '#{address}, #{city}': #{$!.message}"
      print '!'
      nil
    end
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

private

  def set_source
    self.source = 'Montreal'
  end

  def fingerprint
    self.name_fingerprint = name.fingerprint if name_changed?
    self.address_fingerprint = address.fingerprint if address_changed?
    self.city_fingerprint = city.fingerprint if city_changed?
  end

end
