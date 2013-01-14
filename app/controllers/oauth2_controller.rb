class Oauth2Controller < ApplicationController
  before_filter :authenticate_user!
  
  def authorize
    @planet = Planet.find params[:planet_id]
    code = params[:code]
    token = @planet.get_token(code, "http://#{request.host_with_port}")
    response = token.post('/oauth2/get_token_info', params: {access_token: token.token})
    planet_uid = JSON.parse(response.body)['uid']
    response = token.get('/2/users/show.json', params: {uid: planet_uid, access_token: token.token})
    account_data = JSON.parse response.body

    account = Account.find_by_planet_uid planet_uid
    if account.nil?
      account = Account.create! planet_uid: planet_uid, name: account_data['screen_name'], expires_at: Time.at(token.expires_at), access_token: token.token, planet_id: @planet.id
    else
      account.expires_at = Time.at(token.expires_at)
      account.access_token = token.token
      account.save!
    end

    redirect_to planet_accounts_path(@planet)
  end
end
