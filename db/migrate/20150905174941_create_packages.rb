class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :bikeId
      t.text :message

      t.timestamps null: false
    end
  end
end
