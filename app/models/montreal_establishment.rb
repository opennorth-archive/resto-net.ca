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

  before_save :fingerprint

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
