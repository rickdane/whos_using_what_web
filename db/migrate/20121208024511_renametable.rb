class Renametable < ActiveRecord::Migration
  def up
    rename_table :tests, :searches
  end

  def down
  end
end
