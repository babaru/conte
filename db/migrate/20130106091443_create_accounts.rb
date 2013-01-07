class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :planet_uid
      t.string :access_token
      t.string :name
      t.datetime :expires_at
      t.boolean :is_expired
      t.references :planet

      t.timestamps
    end
    add_index :accounts, :planet_id
  end
end
