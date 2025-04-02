class Team < ApplicationRecord
  belongs_to :player

  has_many :team_players, dependent: :destroy
  has_many :players, through: :team_players

  has_many :participations, dependent: :destroy
  has_many :events, through: :participations
  has_many :results, foreign_key: "winner_team_id"

  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :team_players

  def members
    [ player ] + players
  end

  def add_member(player)
    self.team_players.create(player: player, role: "member")
  end

  def remove_member(player)
    self.team_players.where(player: player).destroy_all
  end

  def owner
    self.team_players.find_by(role: "owner")&.player
  end
end
