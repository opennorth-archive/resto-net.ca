class Inspection
  include MongoMapper::Document

  key :source, String
  key :name, String
  key :inspection_date, Date
  timestamps!

  validates_presence_of :inspection_date

  before_save :denormalize
  after_create :increment_cache
  after_destroy :decrement_cache

  def establishment
    raise NotImplementedError
  end

  # @note override this method if necessary
  def date
    inspection_date
  end

private

  def denormalize
    self.source = establishment.source
    self.name = establishment.name
  end

  # @note only runs on inspections with an amount
  def increment_cache
    establishment.increment(fines_count: 1, fines_total: amount) if respond_to? :amount
  end

  # @note only runs on inspections with an amount
  def decrement_cache
    establishment.decrement(fines_count: 1, fines_total: amount) if respond_to? :amount
  end

end
