class CreateTeamMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :team_memberships do |t|
      t.references :player, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :role, default: "member"

      t.timestamps
    end

    add_index :team_memberships, [ :player_id, :team_id ], unique: true
  end
end
