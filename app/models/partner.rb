class Partner < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :address, :admission_date, :birth_date, :document, :email, :lastname, :mobile_phone, :name,
    :phone, :lock_version

  # Default order
  default_scope order('name ASC')

  # Validations
  validates :name, :lastname, :user_id, :presence => true
  validates :document, :email, :uniqueness => true, :allow_nil => true, :allow_blank => true
  validates :name, :uniqueness => { :scope => :lastname }, :allow_nil => true, :allow_blank => true
  validates :address, :email, :lastname, :mobile_phone, :name, :phone, :length => { :maximum => 255 },
    :allow_nil => true, :allow_blank => true
  validates :mobile_phone, :phone, :document, :numericality => { :only_integer => true }, :allow_nil => true,
    :allow_blank => true
  validates_date :birth_date, :on_or_before => lambda { Date.today.years_ago 4 },
    :allow_nil => true, :allow_blank => true
  validates_date :admission_date, :on_or_before => :today, :allow_nil => true, :allow_blank => true
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
    :allow_nil => true, :allow_blank => true

  # Relations
  belongs_to :user
  has_many :assistances, :dependent => :destroy
  has_many :payments, :dependent => :destroy

  def self.filtered_list(query)
    query.present? ?
      where('name ILIKE :q OR lastname ILIKE :q OR email ILIKE :q OR address ILIKE :q',
        :q => "%#{query}%"
      ) : scoped
  end

  def to_s
    [self.name, self.lastname].compact.join(' ')
  end

end
