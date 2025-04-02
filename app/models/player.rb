class Player < ApplicationRecord
  belongs_to :user

  has_many :team_players, dependent: :destroy
  has_many :teams, through: :team_players

  has_many :owned_teams, class_name: "Team", dependent: :destroy

  validates :user_id, uniqueness: true
  validates :name, presence: true

  def all_teams
    owned_teams + teams
  end

  def member_of?(team)
    teams.include?(team) || owned_teams.include?(team)
  end
end
