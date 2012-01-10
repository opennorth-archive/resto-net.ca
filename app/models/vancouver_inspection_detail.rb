class VancouverInspectionDetail
  include MongoMapper::EmbeddedDocument

  key :observation, String
  key :description, String
  key :num_new_observations, Integer
  key :num_resolved_observations, Integer

  belongs_to :vancouver_inspection

end
