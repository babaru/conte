module Oauth2
  class SinaOauth2
    attr_reader :oauth2_client
    attr_reader :oauth2_token

    def initialize(client_id, client_secret)
      @oauth2_client = OAuth2::Client.new(client_id, client_secret, :site => 'https://api.weibo.com', :authorize_url => '/oauth2/authorize', :token_url => '/oauth2/access_token')
    end

    def authorize_url(redirect_uri)
      oauth2_client.auth_code.authorize_url redirect_uri:redirect_uri
    end

    def get_token(code, redirect_uri)
      @oauth2_token = oauth2_client.auth_code.get_token(code, {redirect_uri:redirect_uri, parse:json})
      @oauth2_token
    end
  end
end