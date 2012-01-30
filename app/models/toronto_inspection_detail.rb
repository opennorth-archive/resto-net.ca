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

  after_create :update_establishment_calculated_fields

  validates_presence_of :dinesafe_id, :status

  validates_inclusion_of :status, :in => ['Closed', 'Pass', 'Conditional Pass', 'Out of Business']                                      

  validates_presence_of :severity, :description, :action, :unless => Proc.new {|c| c.pass? || c.out_of_business?} 

  validate :uniqueness_of_dinesafe_id

  validates_inclusion_of :action, :in => ['Notice to Comply', 'Not in Compliance', 'Corrected During Inspection', 'Ticket', 'Summons', 'Order', 'Closure Order', 'Summons and Health Hazard Order'], :unless => Proc.new {|c| c.pass? || c.out_of_business?} 
  validates_inclusion_of :severity, :in => ['C - Crucial', 'S - Significant', 'M - Minor', 'NA - Not Applicable'], :unless => Proc.new {|c| c.pass? || c.out_of_business?} 

  validates_inclusion_of :court_outcome, :in => ['Pending', 'Conviction - Suspended Sentence', 'Conviction - Ordered to Close by Court', 'Conviction - Fined', 'Charges Withdrawn', 'Charges Quashed'], :unless => Proc.new {|c| c.pass? || c.out_of_business?}, :allow_blank => true

  def update_establishment_calculated_fields
    toronto_inspection.update_calculated_fields
  end

  def pass?
    status == 'Pass'
  end

  def out_of_business?
    status == 'Out of Business'
  end

private

  def uniqueness_of_dinesafe_id
    if toronto_inspection.toronto_inspection_details.detect{|detail| detail.dinesafe_id == dinesafe_id && detail.persisted? }
      errors.add :dinesafe_id, "is already taken"
    end
  end

end
