class CreateTeamPlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :team_players do |t|
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end

    # Add index for uniqueness
    add_index :team_players, [ :team_id, :player_id ], unique: true
  end
end
