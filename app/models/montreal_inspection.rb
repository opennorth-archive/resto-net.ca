class MontrealInspection < Inspection
  key :description, String
  key :judgment_date, Date
  key :amount, Float
  
  belongs_to :montreal_establishment

  validates_presence_of :description, :judgment_date, :amount
  validates_numericality_of :amount, only_integer: true

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

private

  def increment_counter_cache
    
  end

  def decrement_counter_cache
    
  end

  def update_establishment_calculated_fields
    self.montreal_establishment.update_calculated_fields
  end

end
