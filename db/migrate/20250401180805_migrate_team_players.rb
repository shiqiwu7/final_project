class MigrateTeamPlayers < ActiveRecord::Migration[8.0]
  def up
    Team.find_each do |team|
      team.players.each do |player|
        TeamPlayer.create(team_id: team.id, player_id: player.id)
      end
    end
  end

  def down
    TeamPlayer.delete_all
  end
end
