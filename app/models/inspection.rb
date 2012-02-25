class Inspection
  include MongoMapper::Document

  key :source, String
  key :name, String
  key :inspection_date, Date
  timestamps!

  validates_presence_of :inspection_date

  before_create :denormalize

  def date
    inspection_date
  end

private

  def denormalize
    self.source = establishment.source
    self.name = establishment.name
  end
end
