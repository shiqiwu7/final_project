class AddRoleToTeamPlayers < ActiveRecord::Migration[8.0]
  def change
    add_column :team_players, :role, :string, default: 'member'
  end
end
