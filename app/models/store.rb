class Store < ApplicationRecord
    has_many :scores
    validates :name, presence: true
end
