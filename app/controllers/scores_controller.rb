class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :destroy]
  
  # GET /scores
  # GET /scores.json
  def index
    @search_params ||= {}
    @search_params[:id] = params[:id]
    @search_params[:user_id] = params[:user_id]
    @search_params[:model] = params[:model]
    @search_params[:play_start] = params[:play_start]
    @search_params[:play_end] = params[:play_end]
    @win_or_lose = params[:win_or_lose]
    # store_id = params[:store_id]

    # binding.pry
    
    relation = Score.all
    relation = relation.where(id: @search_params[:id]) if @search_params[:id].present?
    relation = relation.where(user_id: @search_params[:user_id]) if @search_params[:user_id].present?
    relation = relation.where( "model like ?", "%" + @search_params[:model] + "%") if @search_params[:model].present?
    relation = relation.where( "start_at >= ?", @search_params[:play_start].to_datetime) if @search_params[:play_start].present?
    relation = relation.where( "end_at < ?", @search_params[:play_end].to_datetime.tomorrow) if @search_params[:play_end].present?
    
    case @win_or_lose.to_i
    when 1 then
      relation = relation.where("investment + proceeds > 0")
    when 2 then
      relation = relation.where("investment + proceeds < 0")
    when 3 then
      relation = relation.where("investment + proceeds == 0")
    end
    
    @scores = relation 
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
  end

  # GET /scores/new
  def new
    @score = Score.new
  end

  # GET /scores/1/edit
  def edit
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(score_params)
    # binding.pry
    @score[:user_id] = params[:score_user_id].to_i
    @score[:store_id] = params[:score_store_id].to_i
    
    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: t(:score_was_successfully_created) }
        format.json { render :show, status: :created, location: @score }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scores/1
  # PATCH/PUT /scores/1.json
  def update
    @score[:user_id] = params[:score_user_id]
    @score[:store_id] = params[:score_store_id]
    
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score, notice: t(:score_was_successfully_updated) }
        format.json { render :show, status: :ok, location: @score }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to scores_url, notice: t(:score_was_successfully_destroyed) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:user_id, :store_id, :model, :seat, :start_at, :end_at, :investment, :proceeds)
    end
end
