
class OauthAdapter
  attr_reader :app_key
  attr_reader :app_secret
  attr_reader :api_url

  def initialize(api_url, app_key, app_secret)
    @api_url = api_url
    @app_key = app_key
    @app_secret = app_secret

    Rails.logger.debug "- api_url: #{api_url}"
    Rails.logger.debug "- app_key: #{app_key}"
    Rails.logger.debug "- app_secret: #{app_secret}"
  end

  def authorize(redirect_uri)
    Rails.logger.info "* Authorizing"
    Rails.logger.debug "- redirect_uri: #{redirect_uri}"

    request_data = {}
    request_data[:client_id] = app_key
    request_data[:response_type] = "code"
    request_data[:redirect_uri] = redirect_uri

    "#{api_url}/authorize?client_id=#{app_key}&response_type=code&redirect_uri=#{redirect_uri}"
  end

  def access_token(code, redirect_uri)
    Rails.logger.info "* Requesting Access Token"
    Rails.logger.debug "- code: #{code}"

    request_data = {}
    request_data[:client_id] = app_key
    request_data[:client_secret] = app_secret
    request_data[:grant_type] = "authorization_code"
    request_data[:code] = code
    request_data[:redirect_uri] = redirect_uri

    JSON.parse RestClient.get("#{api_url}/access_token", request_data)
  end
end
