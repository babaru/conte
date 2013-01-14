class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.references :planet
      t.references :user
      t.references :account
      t.datetime :scheduled_at
      t.boolean :is_published
      t.datetime :published_at
      t.string :type
      t.string :sina_weibo_id
      t.string :sina_weibo_url
      t.has_attached_file :image
      t.string :attachment_access_token

      t.timestamps
    end
    add_index :articles, :planet_id
    add_index :articles, :user_id
    add_index :articles, :account_id
  end
end
