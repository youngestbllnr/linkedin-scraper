class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :username
      t.json :metadata
      t.text :document

      t.timestamps
    end
  end
end
