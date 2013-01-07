class Planet < ActiveRecord::Base
  attr_accessible :app_key, :app_secret, :name, :auth_type
  has_many :accounts

  def authorize_url(host)
    auth_client.authorize_url "#{host}/oauth2/authorize/planet/#{self.id}"
  end

  def get_token(code, host)
    auth_client.get_token code, host
  end

  private

  def auth_client
    Oauth2::SinaOauth2.new(app_key, app_secret)
  end

end
