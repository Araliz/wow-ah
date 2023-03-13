class CreateRealms < ActiveRecord::Migration[7.0]
  def change
    create_table :realms do |t|
      t.integer :blizzard_id
      t.string :name
      t.string :region
      t.string :language
      t.string :population

      t.timestamps
    end
  end
end
