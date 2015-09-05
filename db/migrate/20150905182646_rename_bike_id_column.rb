class RenameBikeIdColumn < ActiveRecord::Migration
  def change
    rename_column :packages, :bikeId, :bike_id
  end
end
