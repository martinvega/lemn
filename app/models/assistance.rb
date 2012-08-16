class Assistance < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :date

  # Default order
  default_scope order('date DESC')

  # Validations
  validates :date, :partner_id, :user_id, :presence => true
  validates_date :date, :on_or_before => lambda { Date.current }, :allow_nil => true, :allow_blank => true

  # Relations
  belongs_to :user
  belongs_to :partner

end


