class Planet < ActiveRecord::Base
  attr_accessible :app_key, :app_secret, :name, :auth_type, :domain
  has_many :accounts
  has_many :articles

  domain_regex = /^[a-z0-9]*(\.?[a-z0-9]+)\.[a-z]{2,5}(:[0-9]{1,5})?(\/.)?$/ix

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :domain, presence: true, format: { with: domain_regex }
  validates :auth_type, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def authorize_url(host)
    auth_client.authorize_url "#{host}/oauth2/authorize/planet/#{self.id}"
  end

  def get_token(code, host)
    auth_client.get_token code, host
  end

  def listed_articles_count
    articles.listed.count
  end

  def account_expired?
    accounts.expired.count > 0
  end

  class << self
    def auth_types
      AuthType.auth_types.map{ |k,v| [I18n.t("auth_types.#{k}"),v] }
    end 

    def auth_type_names
      Hash[AuthType.auth_types.map{ |k, v| [v, I18n.t("auth_types.#{k}")]}]
    end
  end

  private

  def auth_client
    case self.auth_type
    when AuthType.auth_types.sina_weibo_oauth2
      Oauth2::SinaOauth2.new(app_key, app_secret)
    else
      nil
    end
  end
end
