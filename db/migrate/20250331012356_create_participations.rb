class CreateParticipations < ActiveRecord::Migration[8.0]
  def change
    create_table :participations do |t|
      t.references :team, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.datetime :registration_date, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
