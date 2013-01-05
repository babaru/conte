class WelcomeController < ApplicationController
  def index
  end

  def authorize
    client = OAuth2::Client.new('3488938016', 'e97940d12d49fa6e8abf0aa87df6efd6', :site => 'https://api.weibo.com', :authorize_url => '/oauth2/authorize', :token_url => '/oauth2/access_token')
    redirect_to client.auth_code.authorize_url(:redirect_uri => "http://conte.sptida.com/welcome/authorized")
  end

  def authorized
    code = params[:code]
    client = OAuth2::Client.new('3488938016', 'e97940d12d49fa6e8abf0aa87df6efd6', :site => 'https://api.weibo.com', :authorize_url => '/oauth2/authorize', :token_url => '/oauth2/access_token')
    begin
      token = client.auth_code.get_token(code, :redirect_uri => 'http://conte.sptida.com')
      Rails.logger.debug token.token
      redirect_to :index
    rescue OAuth2::Error => e
      Rails.logger.debug e.code
    end
  end
end
