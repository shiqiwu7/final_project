class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.references :user, null: false, foreign_key: true
      t.text :bio

      t.timestamps
    end
  end
end
