class Payment < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :amount, :concept, :date, :lock_version, :partner_id
  attr_reader :next_payment_date

  # Default order
  default_scope order('date DESC')

  # Named scopes
  scope :order_date, lambda { |order|
    order('date ?', order)}
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

  def self.filtered_by_date(expired = false)
    if expired
      payments = Payment.between_dates(3.months.ago.to_date, 1.month.ago.to_date)
    else
      payments = Payment.between_dates(1.month.ago.to_date + 1, 1.month.ago.to_date + 7)
    end

    filtered_payments = []
    ids = []

    payments.each do |p|
      unless ids.include? p.partner_id
        ids << p.partner_id
        filtered_payments << p
      end
    end
    if expired
      filtered_payments
    else
      filtered_payments.reverse!
    end
  end
end
