class User < ActiveRecord::Base
  include RoleModel

  roles :admin, :regular

  has_paper_trail



  devise :database_authenticatable, :recoverable, :rememberable, :trackable,
    :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :user, :name, :lastname, :email, :password, :password_confirmation,
    :role, :remember_me, :lock_version

  # Defaul order
  default_scope order('user ASC')

  # Validations
  validates :name, :user, :lastname, :presence => true
  validates :user, :uniqueness => true
  validates :name, :lastname, :email, :user, :length => { :maximum => 255 }, :allow_nil => true,
    :allow_blank => true

  def initialize(attributes = nil, options = {})
    super(attributes, options)

    self.role ||= :regular
  end

  def to_s
    [self.name, self.lastname].compact.join(' ')
  end

  def role
    self.roles.first.try(:to_sym)
  end

  def role=(role)
    self.roles = [role]
  end

  def self.filtered_list(query)
    query.present? ? all : scoped
  end
end
