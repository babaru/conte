class WelcomeController < ApplicationController
  def index
  end

  def authorize
    client = Oauth2::SinaOauth2.new('3488938016', 'e97940d12d49fa6e8abf0aa87df6efd6')
    redirect_to client.authorize_url("http://conte.sptida.com/welcome/authorized")
  end

  def authorized
    code = params[:code]
    client = Oauth2::SinaOauth2.new('3488938016', 'e97940d12d49fa6e8abf0aa87df6efd6')
    token = client.get_token('http://conte.sptida.com')
    redirect_to action:index
  end
end
