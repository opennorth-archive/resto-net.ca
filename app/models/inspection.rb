class Inspection
  include MongoMapper::Document

  key :source, String
  key :name, String
  key :inspection_date, Date
  timestamps!

  validates_presence_of :inspection_date

  before_create :denormalize
  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  def date
    inspection_date
  end

private

  def denormalize
    self.source = establishment.source
    self.name = establishment.name
  end

  def increment_counter_cache
    establishment.increment(fines_count: 1, fines_total: amount) if respond_to? :amount
  end

  def decrement_counter_cache
    establishment.decrement(fines_count: 1, fines_total: amount) if respond_to? :amount
  end

end
