class CreateQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :queries do |t|
      t.string :input
      t.string :revised_input
      t.json :output

      t.timestamps
    end
  end
end
