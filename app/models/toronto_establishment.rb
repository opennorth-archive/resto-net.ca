class TorontoEstablishment < Establishment
  
  key :dinesafe_id, Integer
  key :city, String
  key :address, String
  key :establishment_type, String

  many :toronto_inspections

  validates_presence_of :address, :city, :establishment_type, :dinesafe_id

  def self.find_or_create_by_dinesafe_id(dinesafe_id, attributes = {})
    establishment = find_by_name_dinesafe_id( dinesafe_id )

    if establishment
      establishment
    else
      create!({
        :dinesafe_id => dinesafe_id
      }.merge(attributes))
    end
  end

private

  def set_source
    self.source = 'Toronto'
  end

end
