class WelcomeController < ApplicationController
  def index

  end

  def authorize
    client = Oauth2::SinaOauth2.new('3488938016', 'e97940d12d49fa6e8abf0aa87df6efd6')
    redirect_to client.authorize_url("http://conte.sptida.com/oauth2/authorized/planet/1")
  end

  def authorized
    code = params[:code]
    client = Oauth2::SinaOauth2.new('3488938016', 'e97940d12d49fa6e8abf0aa87df6efd6')
    token = client.get_token(code, 'http://conte.sptida.com')
    response = token.post('/oauth2/get_token_info', params: {access_token: token.token})
    planet_uid = JSON.parse(response.body)['uid']

    response = token.get('/2/users/show.json', params: {uid: planet_uid, access_token: token.token})
    account_data = JSON.parse response.body

    Rails.logger.info response.body
    redirect_to action:index
  end
end
