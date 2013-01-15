class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @planets_grid = initialize_grid(Planet)
  end
end
