class DashboardController < ApplicationController
  before_filter :authenticate_user!
  skip_authorization_check
  
  def index
    @planets_grid = initialize_grid(Planet, name: 'planets_grid')
    @listed_articles_grid = initialize_grid(Article.where(is_published: false),
      order: 'articles.scheduled_at',
      order_direction: 'desc',
      name: 'listed_articles_grid')
  end
end
