class VancouverEstablishment < Establishment
  key :address, String
  key :establishment_type, String
  key :vch_id, String
  key :owner_name, String
  key :operator_name, String
  key :capacity, Integer

  many :vancouver_inspections, dependent: :destroy

  def self.source
    'vancouver'
  end

end

