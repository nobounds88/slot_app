class Score < ApplicationRecord
    belongs_to :user
    belongs_to :store
    validates :user_id, presence: true
    validates :store_id, presence: true
    validates :start_at, presence: true
    validates :end_at, presence: true
    
end
