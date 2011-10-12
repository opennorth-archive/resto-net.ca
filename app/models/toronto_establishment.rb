class TorontoEstablishment < Establishment
  
  key :dinesafe_id, Integer
  key :city, String
  key :address, String
  key :establishment_type, String

  many :toronto_inspections

  validates_presence_of :address, :city, :establishment_type, :dinesafe_id

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

private

  def set_source
    self.source = 'Toronto'
  end

end
