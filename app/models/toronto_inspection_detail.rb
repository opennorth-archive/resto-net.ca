class TorontoInspectionDetail
  include MongoMapper::EmbeddedDocument

  key :description, String
  key :severity, String
  key :action, String
  key :court_outcome, String
  key :amount, Float
  key :status, String
  key :dinesafe_id, Integer

  belongs_to :toronto_inspection

  validates_presence_of :dinesafe_id, :status

  validates_inclusion_of :status, :in => ['Closed', 'Pass', 'Conditional Pass']                                      

  validates_presence_of :severity, :description, :action, :unless => :pass?

  validate :uniqueness_of_dinesafe_id

  validates_inclusion_of :action, :in => ['Notice to Comply', 'Not in Compliance', 'Corrected During Inspection', 'Ticket', 'Summons', 'Order', 'Closure Order', 'Summons and Health Hazard Order'], :unless => :pass?                                  
  validates_inclusion_of :severity, :in => ['C - Crucial', 'S - Significant', 'M - Minor', 'NA - Not Applicable'], :unless => :pass?                                       

  validates_inclusion_of :court_outcome, :in => ['Pending', 'Conviction - Suspended Sentence', 'Conviction - Ordered to Close by Court', 'Conviction - Fined', 'Charges Withdrawn', 'Charges Quashed'], :unless => :pass?, :allow_blank => true

  def pass?
    status == 'Pass'
  end

private

  def uniqueness_of_dinesafe_id
    if toronto_inspection.toronto_inspection_details.detect{|detail| detail.dinesafe_id == dinesafe_id && detail.persisted? }
      errors.add :dinesafe_id, "is already taken"
    end
  end

end
