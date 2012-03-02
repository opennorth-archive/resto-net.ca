class MontrealInspection < Inspection
  key :description, String
  key :judgment_date, Date
  key :amount, Float # interoperable with Toronto

  belongs_to :montreal_establishment

  validates_presence_of :description, :judgment_date, :amount
  validates_numericality_of :amount, only_integer: true, greater_than: 0, allow_blank: true

  def establishment
    montreal_establishment
  end

  def date
    judgment_date
  end

  def contravention
    @contravention ||= I18n.t(:regulations)[description.to_sym]
  end

end
