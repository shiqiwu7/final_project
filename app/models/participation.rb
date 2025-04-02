class Participation < ApplicationRecord
  belongs_to :team
  belongs_to :event

  validates :team_id, uniqueness: { scope: :event_id, message: "is already registered for this event" }
  validates :status, inclusion: { in: %w[pending approved rejected completed] }

  before_validation :set_defaults

  private

  def set_defaults
    self.status ||= "pending"
    self.registration_date ||= Time.current
  end
end
