class PlanetAuthorize < ActiveRecord::Migration
  def up
    add_column :planets, :auth_type, :integer
  end

  def down
    remove_column :planets, :auth_type
  end
end
