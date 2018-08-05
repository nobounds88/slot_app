class User < ApplicationRecord
  has_many :blogs, dependent: :destroy
  has_many :scores, dependent: :destroy, autosave: true
  has_many :store_users, dependent: :destroy
  has_many :stores, through: :store_users

  attr_accessor :login

  # validates :username,
  # uniqueness: { case_sensitive: :false },
  # length: { minimum: 3, maximum: 20 },
  # format: { with: /\A[a-z0-9]+\z/, message: "ユーザー名は半角英数字です"}

  # extend Enumerize
  # enumerize :gender, in: [:unknown, :male, :female], default: :unknown, scope: true

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
    else
      where(conditions).first
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable#, :confirmable, :authentication_keys => [:login]
  validates :name,  presence: true, length: { maximum: 50 }

end
