
class Article < ActiveRecord::Base
  include AttachmentAccessToken
  before_create :generate_access_token
  after_create :schedule

  belongs_to :planet
  belongs_to :user
  belongs_to :account
  attr_accessible :body, :is_published, :published_at, :scheduled_at, :sina_weibo_id, :sina_weibo_url, :title, :type, :user_id, :planet_id, :image, :attachment_access_token, :account_id
  has_attached_file :image, :styles => { :thumb => "100x100>" }, :path => ":rails_root/public:url", :url => "/system/images/:attachment_access_token/pic_:style.:extension"

  def schedule
    unless self.scheduled_at.nil?
      scheduler = ::Rufus::Scheduler.start_new
      scheduler.at self.scheduled_at.to_s do
        Article.trigger self.id
      end
    end
  end

  class << self
    def trigger(article_id)
      article = Article.find article_id
      if article
        api = SinaWeibo::ApiWrapper.new article.account.access_token
        response = nil
        if article.image.exists?
          response = api.status_upload article.body, article.image.path
        else
          response = api.status_update article.body
        end

        logger.debug response["id"]
        article.published_at = response["created_at"]
        article.sina_weibo_id = response["id"]
        mid_response = api.querymid response["id"]
        article.sina_weibo_url = "http://weibo.com/#{response['user']['id']}/#{mid_response["mid"]}"
        article.is_published = true
        article.save!
      end
    end
  end
end
