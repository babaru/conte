class WelcomeController < ApplicationController
  def index
    oa = OauthAdapter.new "https://api.weibo.com/oauth2", "3488938016", "e97940d12d49fa6e8abf0aa87df6efd6"
    redirect_to oa.authorize "http://conte.sptida.com/welcome/authorized"
  end

  def authorized
    code = params[:code]
    oa = OauthAdapter.new "https://api.weibo.com/oauth2", "3488938016", "e97940d12d49fa6e8abf0aa87df6efd6"
    Rails.logger.debug oa.access_token(code, "http://conte.sptida.com/success")
  end
end
