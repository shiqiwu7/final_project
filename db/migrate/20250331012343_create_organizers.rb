class CreateOrganizers < ActiveRecord::Migration[8.0]
  def change
    create_table :organizers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :organization

      t.timestamps
    end
  end
end
