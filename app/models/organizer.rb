class Organizer < ApplicationRecord
  belongs_to :user
  has_many :events, dependent: :destroy

  validates :user_id, uniqueness: true
end
