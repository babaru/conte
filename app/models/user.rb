class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :role_id
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id

  validates :email, presence: true
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :role_id, presence: true, numericality: { greater_than: 0 }

  has_and_belongs_to_many :roles

  def role?(role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def role_id
    if roles.count > 0
      return roles[0].id
    end
    return 0
  end
end
