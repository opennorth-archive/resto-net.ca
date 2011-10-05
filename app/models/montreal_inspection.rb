class MontrealInspection < Inspection
  
  key :description, String
  key :judgment_date, Date
  
  belongs_to :montreal_establishment

  validates_presence_of :amount, :judgment_date, :description
  validates_numericality_of :amount, :only_integer => true

end
