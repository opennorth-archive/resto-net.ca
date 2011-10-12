class TorontoEstablishment < Establishment
  
  key :dinesafe_id, Integer
  key :city, String
  key :address, String
  key :establishment_type, String
  key :minimum_inspections_per_year, Integer

  many :toronto_inspections

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

private

  def set_source
    self.source = 'Toronto'
  end

end
