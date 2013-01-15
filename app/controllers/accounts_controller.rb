class AccountsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /accounts
  # GET /accounts.json
  def index
    @accounts_grid = initialize_grid(Account.where(planet_id: params[:planet_id]))
    @planet = Planet.find params[:planet_id]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accounts_grid }
    end
  end

  def auth
    @planet = Planet.find params[:planet_id]
    redirect_to @planet.authorize_url "#{request.protocol}#{@planet.domain}"
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account = Account.find(params[:id])
    @planet = @account.planet
    @account.destroy

    respond_to do |format|
      format.html { redirect_to planet_accounts_url(@planet) }
      format.json { head :no_content }
    end
  end
end
