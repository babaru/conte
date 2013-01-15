class PlanetHasOwnDomain < ActiveRecord::Migration
  def up
    add_column :planets, :domain, :string
  end

  def down
    remove_column :planets, :domain
  end
end
