class Payment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :amount, :concept, :date

  # Default order
  default_scope order('date DESC')

  # Validations
  validates :date, :amount, :concept, :partner_id, :user_id, :presence => true
  validates :concept, :length => { :maximum => 255 }, :allow_nil => true, :allow_blank => true
  validates :amount, :numericality => { :maximum => 9999 }, :allow_nil => true, :allow_blank => true
  validates :date, :timeliness => {:on_or_before => lambda { Date.current }, :type => :date},
    :allow_nil => true, :allow_blank => true

  # Relations
  belongs_to :user
  belongs_to :partner

  def self.filtered_list(query)
    query.present? ?
      where('date LIKE :q OR concept LIKE :q', :q => "%#{query.downcase}%") : scoped
  end

end
