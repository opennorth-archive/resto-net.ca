class TorontoInspection < Inspection
  key :dinesafe_id, Integer # inspection ID
  key :amount, Float
  
  belongs_to :toronto_establishment
  many :toronto_inspection_details

  validates_presence_of :dinesafe_id
  validates_numericality_of :amount, allow_blank: true
  validates_uniqueness_of :dinesafe_id

  scope :fined, where(:amount.gt => 0) # @todo use blank scope instead

  def establishment
    toronto_establishment
  end

  def self.find_or_create_by_dinesafe_id(dinesafe_id, attributes = {})
    find_by_dinesafe_id(dinesafe_id) || create!({
      dinesafe_id: dinesafe_id,
    }.merge(attributes))
  end

end
