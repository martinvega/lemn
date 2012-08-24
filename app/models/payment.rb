class Payment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :amount, :concept, :date, :lock_version, :partner_id
  attr_reader :next_payment_date

  # Default order
  default_scope order('date DESC')

  # Named scopes
  scope :by_partner, lambda { |id| where('partner_id = ?', id) }
  scope :distinct_partner, select('distinct partner_id')
  scope :next_payments, lambda {
    where('date between :start AND :end',
      :start => Date.today - 3.months,
      :end => Date.today.prev_month + 3.days
    )
  }
  # Validations
  validates :date, :amount, :concept, :partner_id, :user_id, :presence => true
  validates :concept, :length => { :maximum => 255 }, :allow_nil => true, :allow_blank => true
  validates :amount, :numericality => { :maximum => 9999 }, :allow_nil => true, :allow_blank => true
  validates_date :date, :on_or_before => lambda { Date.current }, :allow_nil => true,
    :allow_blank => true

  # Relations
  belongs_to :user
  belongs_to :partner

  def self.filtered_list(query)
    query.present? ?
      where('date LIKE :q OR concept LIKE :q', :q => "%#{query.downcase}%") : scoped
  end

  def next_payment_date
    self.date.next_month
  end
end
