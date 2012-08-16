class Partner < ActiveRecord::Base
  has_paper_trail

  # Setup accessible (or protected) attributes for your model
  attr_accessible :address, :admission_date, :birth_date, :document, :email, :lastname, :mobile_phone, :name, :phone

  # Default order
  default_scope order('lastname DESC')

  # Validations
  validates :name, :lastname, :user_id, :presence => true
  validates :document, :email, :uniqueness => true
  validates :address, :document, :email, :lastname, :mobile_phone, :name, :phone, :length => { :maximum => 255 },
    :allow_nil => true, :allow_blank => true
  validates :mobile_phone, :phone, :document, :numericality => { :only_integer => true }, :allow_nil => true,
    :allow_blank => true
  validates_date :birth_date, :on_or_before => lambda { Date.current }, :allow_nil => true,
    :allow_blank => true
  validates_date :admission_date, :on_or_before => lambda { Date.current }, :allow_nil => true,
    :allow_blank => true
  validates :email, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
    :allow_nil => true, :allow_blank => true

  # Relations
  belongs_to :user
  has_many :assistances, :dependent => :destroy
  has_many :payments, :dependent => :destroy

end
