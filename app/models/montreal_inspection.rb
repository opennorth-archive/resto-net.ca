class MontrealInspection < Inspection
  key :description, String
  key :judgment_date, Date
  key :amount, Float # interoperable with Toronto

  belongs_to :montreal_establishment

  validates_presence_of :description, :judgment_date, :amount
  validates_numericality_of :amount, only_integer: true, greater_than: 0, allow_blank: true

  scope :fined, where(:amount.gt => 0) # @todo use blank scope instead

  def establishment
    montreal_establishment
  end

  def regulation
    @regulation ||= I18n.t(:regulations)[description.to_sym]
  end

end
