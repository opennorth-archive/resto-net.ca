class VancouverInspection < Inspection

  key :inspector, String
  key :follow_up_required, Boolean
  key :reason, String
  key :action, String
  key :referrals, String
  key :general_comments, String
  key :closing_comments, String
  
  many :vancouver_inspection_details

  belongs_to :vancouver_establishment


end
