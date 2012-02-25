class MontrealEstablishment < Establishment
  key :address, String
  key :city, String
  key :establishment_type, String
  key :owner_name, String
  key :name_fingerprint, String
  key :address_fingerprint, String
  key :city_fingerprint, String
  key :total_fines, Float 

  many :montreal_inspections, :dependent => :destroy

  validates_presence_of :address, :city, :establishment_type, :owner_name

  before_create :geocode
  before_save :fingerprint

  scope :geocoded, where(:latitude => {:$ne => :nil}, :longitude => {:$ne => :nil})

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

  def update_calculated_fields
    self.total_fines = montreal_inspections.sum(:amount)
    self.judgments_span = montreal_inspections.maximum(:judgment_date) - montreal_inspections.minimum(:judgment_date)
    save!
  end

private

  def set_source
    self.source = 'montreal'
  end

  def fingerprint
    self.name_fingerprint = name.fingerprint if name_changed?
    self.address_fingerprint = address.fingerprint if address_changed?
    self.city_fingerprint = city.fingerprint if city_changed?
  end

end
