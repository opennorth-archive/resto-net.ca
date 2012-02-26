class MontrealInspection < Inspection
  key :description, String
  key :judgment_date, Date
  key :amount, Float # interoperable with Toronto

  belongs_to :montreal_establishment

  validates_presence_of :description, :judgment_date, :amount
  validates_numericality_of :amount, only_integer: true

  def establishment
    montreal_establishment
  end

  def date
    judgment_date
  end

end
