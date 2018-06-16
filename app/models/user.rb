class User < ApplicationRecord
  has_many :blogs, dependent: :destroy
  has_many :scores, dependent: :destroy, autosave: true

  extend Enumerize
  enumerize :gender, in: [:unknown, :male, :female], default: :unknown, scope: true
  
  # mens = User.with_gender(:male)
  # wemens = User.with_gender(:female)
  # users = User.without_gender(:male)
  # User.gender.options
  # f.select :gender, options_for_select(User.gender.options)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name,  presence: true, length: { maximum: 50 }
  
end
