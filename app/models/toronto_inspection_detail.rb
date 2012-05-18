class TorontoInspectionDetail
  include MongoMapper::EmbeddedDocument

  key :dinesafe_id, Integer # row ID
  key :description, String
  key :severity, String
  key :action, String
  key :court_outcome, String
  key :amount, Float
  key :status, String

  belongs_to :toronto_inspection

  validates_presence_of :dinesafe_id, :status
  validates_presence_of :severity, :description, :action, unless: -> {|c| c.pass? || c.out_of_business?}
  validates_numericality_of :amount, allow_blank: true # has cents, can be zero
  validates_inclusion_of :status, in: [
    'Closed',
    'Pass',
    'Conditional Pass',
    'Out of Business',
  ]
  validates_inclusion_of :action, in: [
    'Notice to Comply',
    'Not in Compliance',
    'Corrected During Inspection',
    'Ticket',
    'Summons',
    'Order',
    'Closure Order',
    'Summons and Health Hazard Order',
  ], unless: -> {|c| c.pass? || c.out_of_business?} , allow_blank: true
  validates_inclusion_of :severity, in: [
    'C - Crucial',
    'S - Significant',
    'M - Minor',
    'NA - Not Applicable',
  ], unless: -> {|c| c.pass? || c.out_of_business?} , allow_blank: true
  validates_inclusion_of :court_outcome, in: [
    'Pending',
    'Conviction - Suspended Sentence',
    'Conviction - Ordered to Close by Court',
    'Conviction - Fined',
    'Charges Withdrawn',
    'Charges Quashed',
  ], unless: -> {|c| c.pass? || c.out_of_business?}, allow_blank: true
  validate :uniqueness_of_dinesafe_id

  after_create :increment_cache
  after_destroy :decrement_cache

  def pass?
    status == 'Pass'
  end

  def out_of_business?
    status == 'Out of Business'
  end

private

  def uniqueness_of_dinesafe_id
    if toronto_inspection.toronto_inspection_details.detect{|detail| detail.dinesafe_id == dinesafe_id && detail.persisted? }
      errors.add :dinesafe_id, 'is already taken'
    end
  end

  def increment_cache
    toronto_inspection.increment(amount: amount) if amount
  end

  def increment_cache
    toronto_inspection.decrement(amount: amount) if amount
  end

end
