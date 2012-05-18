class MontrealEstablishment < Establishment
  key :address, String
  key :city, String
  key :establishment_type, String
  key :owner_name, String
  key :name_fingerprint, String
  key :address_fingerprint, String
  key :city_fingerprint, String
  key :fines_count, Integer
  key :fines_total, Float

  many :montreal_inspections, dependent: :destroy

  validates_presence_of :address, :city, :establishment_type, :owner_name

  before_create :geocode
  before_save :fingerprint

  def inspections
    montreal_inspections
  end

  def self.source
    'montreal'
  end

  def self.only_fines?
    true
  end

  # @note doesn't update attributes on existing records
  def self.find_or_create_by_name_and_address_and_city(name, address, city, attributes = {})
    find_by_name_fingerprint_and_address_fingerprint_and_city_fingerprint(
      name.fingerprint,
      address.fingerprint,
      city.fingerprint
    ) || create!({
      name: name,
      address: address,
      city: city,
    }.merge(attributes))
  end

private

  def fingerprint
    self.name_fingerprint = name.fingerprint if name_changed?
    self.address_fingerprint = address.fingerprint if address_changed?
    self.city_fingerprint = city.fingerprint if city_changed?
  end

end
