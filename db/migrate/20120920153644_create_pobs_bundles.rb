class CreatePobsBundles < ActiveRecord::Migration
  def self.up
    create_table :pobs_bundles do |t|
      t.references :tour
      t.float :south
      t.float :north
      t.float :west
      t.float :east

      t.string :link_to_bundle

      t.timestamps
    end

    add_index :pobs_bundles, [:south, :north, :west, :east]
  end

  def self.down
    drop_table :pobs_bundles
  end
end
