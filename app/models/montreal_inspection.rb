class MontrealInspection < Inspection
  key :description, String
  key :judgment_date, Date
  key :amount, Float
  
  belongs_to :montreal_establishment

  after_create :update_establishment_calculated_fields

  validates_presence_of :amount, :judgment_date, :description
  validates_numericality_of :amount, :only_integer => true

  delegate :owner_name, :to => :montreal_establishment

  def update_establishment_calculated_fields
    self.montreal_establishment.update_calculated_fields
  end

end
