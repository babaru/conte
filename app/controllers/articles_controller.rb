class ArticlesController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /articles
  # GET /articles.json
  def index
    @planet = Planet.find params[:planet_id]
    if params[:published]
      @articles_grid = initialize_grid(Article.where(planet_id: params[:planet_id], is_published: true),
        :order => 'updated_at',
        :order_direction => 'desc'
      )
    else
      @articles_grid = initialize_grid(Article.where(planet_id: params[:planet_id], is_published: false),
        :order => 'scheduled_at',
        :order_direction => 'asc'
      )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles_grid }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @planet = Planet.find params[:planet_id]
    @article = Article.new
    @article.planet = @planet

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    @planet = Planet.find params[:planet_id]
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to planet_articles_path(@article.planet_id), notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to planet_articles_path(@article.planet_id), notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @planet_id = @article.planet_id
    @article.destroy

    respond_to do |format|
      format.html { redirect_to planet_articles_path(@planet_id) }
      format.json { head :no_content }
    end
  end

  def publish
    @article = Article.find params[:id]
    if request.post?
      begin
        @article.trigger
        redirect_to planet_articles_path(@article.planet_id), notice: 'Article was successfully sent.'
      rescue => e
        redirect_to planet_articles_path(@article.planet_id), alert: e.message
      end
    end
  end
end
