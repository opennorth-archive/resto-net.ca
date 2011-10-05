class Inspection
  include MongoMapper::Document

  key :amount, Float
  key :inspection_date, Date
  timestamps!

  validates_presence_of :inspection_date

end
