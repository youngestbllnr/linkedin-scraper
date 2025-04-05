class AddVectorColumnToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :embedding, :vector, limit: 1536
  end
end
