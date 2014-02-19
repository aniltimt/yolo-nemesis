class AddCountryAndCityToTours < ActiveRecord::Migration
  def self.up
    change_table :tours do |t|
      t.string :country
      t.string :city
    end
  end

  def self.down
    remove_column :tours, :country
    remove_column :tours, :city
  end
end
