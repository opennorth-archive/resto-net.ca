class TorontoEstablishment < Establishment
  
  key :dinesafe_id, Integer
  key :city, String
  key :address, String
  key :establishment_type, String

  many :toronto_inspections

  validates_presence_of :address, :city, :establishment_type, :dinesafe_id

private

  def set_source
    self.source = 'Toronto'
  end

end
