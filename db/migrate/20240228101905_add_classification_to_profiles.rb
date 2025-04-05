class AddClassificationToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :classification, :string
  end
end
