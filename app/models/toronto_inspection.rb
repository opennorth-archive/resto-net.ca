class TorontoInspection < Inspection

  key :dinesafe_id, Integer
  key :description, String
  key :severity, String
  key :action, String
  key :court_outcome, String
  key :status, String
  key :minimum_inspections_per_year, Integer
  timestamps!

  validates_presence_of :minimum_inspections_per_year, :status, :dinesafe_id

  validates_presence_of :severity, :description, :action, :amount, :unless => :pass

  validates_numericality_of :minimum_inspections_per_year, :only_integer => true, :greater_than => 0, :allow_blank => true

  validates_inclusion_of :status, :in => ['Closed', 'Pass', 'Conditional Pass']                                      
  validates_inclusion_of :severity, :in => ['C - Crucial', 'S - Significant', 'M - Minor', 'NA - Not Applicable'], :unless => :pass                                        
  validates_inclusion_of :action, :in => ['Notice to Comply', 'Corrected During Inspection', 'Ticket', 'Summons', 'Order', 'Closure Order', 'Summons and Health Hazard Order'], :unless => :pass                                    
  def pass
    status == 'Pass'
  end

end
