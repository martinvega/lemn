class Assistance < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :date, :lock_version, :partner_id

  # Default order
  default_scope order('date DESC')

  # Named scopes
  scope :by_partner, lambda { |id| where('partner_id = ?', id) }

  # Validations
  validates :date, :partner_id, :user_id, :presence => true
  validates_date :date, :on_or_before => :today, :allow_nil => true, :allow_blank => true
  validates :date, :uniqueness => { :scope => :partner_id }

  # Relations
  belongs_to :user
  belongs_to :partner

  def self.filtered_list(query)
    query.present? ?
      where('date LIKE :q', :q => "%#{query}%") : scoped
  end
end


