class Result < ApplicationRecord
  belongs_to :event
  belongs_to :winner_team, class_name: "Team", foreign_key: "winner_team_id"

  validates :event_id, uniqueness: true
  validates :score, presence: true

  validate :winner_participated_in_event

  private

  def winner_participated_in_event
    unless event.teams.include?(winner_team)
      errors.add(:winner_team, "must be a participant in the event")
    end
  end
end
