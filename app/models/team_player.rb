class TeamPlayer < ApplicationRecord
  belongs_to :team
  belongs_to :player

  validates :team_id, uniqueness: { scope: :player_id }
  validates :role, inclusion: { in: [ "owner", "member" ] }

  def owner?
    role == "owner"
  end

  def member?
    role == "member"
  end
end
