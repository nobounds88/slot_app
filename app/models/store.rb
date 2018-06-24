class Store < ApplicationRecord
    has_many :users
    has_many :scores
    has_many :store_users, dependent: :delete_all
    
    validates :name, presence: true
    serialize :informations
end
