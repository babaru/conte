
class Article < ActiveRecord::Base
  include AttachmentAccessToken
  before_create :generate_access_token
  after_create :schedule

  belongs_to :planet
  belongs_to :user
  belongs_to :account
  attr_accessible :body, :is_published, :published_at, :scheduled_at, :sina_weibo_id, :sina_weibo_url, :title, :type, :user_id, :planet_id, :image, :attachment_access_token, :account_id
  has_attached_file :image, :styles => { :thumb => "100x100>" }, :path => ":rails_root/public:url", :url => "/system/images/:image_access_token/pic_:style.:extension"

  def schedule
    unless self.scheduled_at.nil?
      scheduler = ::Rufus::Scheduler.start_new
      scheduler.at self.scheduled_at.to_s do
        Article.trigger self.id
      end
    end
  end

  def trigger
    api = SinaWeibo::ApiWrapper.new self.account.access_token
    response = nil
    if self.image.exists?
      response = api.status_upload self.body, self.image.path
    else
      response = api.status_update self.body
    end

    logger.debug response["id"]
    self.published_at = response["created_at"]
    self.sina_weibo_id = response["id"]
    mid_response = api.querymid response["id"]
    self.sina_weibo_url = "http://weibo.com/#{response['user']['id']}/#{mid_response["mid"]}"
    self.is_published = true
    self.save!
  end
end
