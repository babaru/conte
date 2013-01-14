class Article < ActiveRecord::Base
  include AttachmentAccessToken

  belongs_to :planet
  belongs_to :user
  belongs_to :account
  attr_accessible :body, :is_published, :published_at, :scheduled_at, :sina_weibo_id, :sina_weibo_url, :title, :type, :user_id, :planet_id, :image, :attachment_access_token, :account_id
  has_attached_file :image, :styles => { :thumb => "100x100>" }, :path => ":rails_root/public:url", :url => "/system/images/:image_access_token/pic_:style.:extension"

end
