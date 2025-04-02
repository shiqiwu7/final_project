class CreateResults < ActiveRecord::Migration[8.0]
  def change
    create_table :results do |t|
      t.references :event, null: false, foreign_key: true, index: { unique: true }
      t.references :winner_team, null: false, foreign_key: { to_table: :teams }
      t.string :score, null: false
      t.text :details

      t.timestamps
    end
  end
end
