class Payment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :amount, :concept, :date, :lock_version, :partner_id
  attr_reader :next_payment_date

  # Default order
  default_scope order('date DESC')

  # Named scopes
  scope :by_partner, lambda { |id|
    where('partner_id = ?', id)
  }
  scope :between_dates, lambda { |from, to|
    where('date between :from AND :to',
      :from => from,
      :to => to
    )
  }
  # Validations
  validates :date, :amount, :concept, :partner_id, :user_id, :presence => true
  validates :concept, :length => { :maximum => 255 }, :allow_nil => true, :allow_blank => true
  validates :amount, :numericality => { :maximum => 9999 }, :allow_nil => true, :allow_blank => true
  validates_date :date, :on_or_before => :today, :allow_nil => true, :allow_blank => true
  validates :date, :uniqueness => { :scope => :partner_id }

  # Relations
  belongs_to :user
  belongs_to :partner

  def self.filtered_list(query)
    query.present? ?
      where('concept LIKE :q', :q => "%#{query.downcase}%") : scoped
  end

  def next_payment_date
    self.date.next_month
  end

  def to_s
    self.concept
  end

  def self.next_to_expire
    payments = Payment.between_dates(1.month.ago.to_date + 1, 1.month.ago.to_date + 7)

    filtered_payments = []
    ids = []

    payments.each do |p|
      id = p.partner_id
      if ids.exclude? id
        ids << id
        filtered_payments << p
      end
    end

    filtered_payments.reverse!
  end

  def self.expired
    payments = Payment.between_dates(3.months.ago.to_date, 1.month.ago.to_date)
    not_expired = Payment.select('partner_id').between_dates(1.month.ago.to_date + 1, Date.today).map(
      &:partner_id
    )

    filtered_payments = []
    ids = []

    payments.each do |p|
      id = p.partner_id
      if ids.exclude?(id) && not_expired.exclude?(id)
        ids << id
        filtered_payments << p
      end
    end

    filtered_payments
  end
end
