class TorontoInspection < Inspection

  key :dinesafe_id, Integer
  timestamps!
  
  many :toronto_inspection_details

  belongs_to :toronto_establishment

  validates_presence_of :dinesafe_id

  validates_uniqueness_of :dinesafe_id
 
  def self.find_or_create_by_dinesafe_id(dinesafe_id, attributes = {})
    inspection = find_by_dinesafe_id( dinesafe_id )

    if inspection 
      inspection 
    else
      create!({
        :dinesafe_id => dinesafe_id
      }.merge(attributes))
    end
  end

end
