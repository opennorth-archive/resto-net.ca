class TorontoEstablishment < Establishment
  key :dinesafe_id, Integer
  key :city, String
  key :address, String
  key :establishment_type, String
  key :minimum_inspections_per_year, Integer
  key :fines_count, Integer
  key :fines_total, Float

  many :toronto_inspections, dependent: :destroy

  before_create :geocode

  validates_presence_of :address, :city, :establishment_type, :dinesafe_id, :minimum_inspections_per_year
  validates_numericality_of :minimum_inspections_per_year, only_integer: true, greater_than: 0, allow_blank: true
  validates_uniqueness_of :dinesafe_id

  def inspections
    toronto_inspections
  end

  def self.source
    'toronto'
  end

  def self.find_or_create_by_dinesafe_id(dinesafe_id, attributes = {})
    find_by_dinesafe_id(dinesafe_id) || create!({
      dinesafe_id: dinesafe_id
    }.merge(attributes))
  end

end
