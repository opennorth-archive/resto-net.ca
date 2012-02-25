class MontrealInspection < Inspection
  key :description, String
  key :judgment_date, Date
  key :amount, Float # interoperable with Toronto

  belongs_to :montreal_establishment

  validates_presence_of :description, :judgment_date, :amount
  validates_numericality_of :amount, only_integer: true

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  def establishment
    montreal_establishment
  end

  def date
    judgment_date
  end

private

  def increment_counter_cache
    montreal_establishment.increment fines_count: 1, fines_total: amount
  end

  def decrement_counter_cache
    montreal_establishment.decrement fines_count: 1, fines_total: amount
  end

end
