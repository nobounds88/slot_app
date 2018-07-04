class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :update_ajax, :destroy]
  before_action :authenticate_user!
  
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
    relation = Score.includes(:user, :store)
    relation = relation.where(id: @search_params[:id]) if @search_params[:id].present?
    # relation = relation.where(user_id: @search_params[:user_id]) if @search_params[:user_id].present?
    relation = relation.where(user_id: current_user.id)
    relation = relation.where( "model like ?", "%" + @search_params[:model] + "%") if @search_params[:model].present?
    relation = relation.where( "start_at >= ?", @search_params[:play_start].to_datetime) if @search_params[:play_start].present?
    relation = relation.where( "end_at < ?", @search_params[:play_end].to_datetime.tomorrow) if @search_params[:play_end].present?
    
    case @win_or_lose.to_i
    when 1 then
      relation = relation.where("proceeds - investment > 0")
    when 2 then
      relation = relation.where("proceeds - investment < 0")
    when 3 then
      relation = relation.where("proceeds - investment == 0")
    end
    
    @scores = relation.order(:start_at)
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
  end

  # GET /scores/new
  def new
    @score = Score.new
    @score[:seat] = "0000"
    t = Time.current
    t = t - (t.hour - 10) * 3600 - t.min * 60 - t.sec
    @score[:start_at] = t
  end
  
  # GET /scores/1/edit
  def edit
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(score_params)
    @score[:user_id] = current_user.id
    
    respond_to do |format|
      if @score.save
        format.html { redirect_to @score, notice: t(:was_successfully_created) }
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
    @score[:user_id] = current_user.id
    @score[:store_id] = params[:score_store_id]
    
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score, notice: t(:was_successfully_updated) }
        format.json { render :show, status: :ok, location: @score }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_ajax
    @score[:start_at] = params[:start_at].to_time
    @score[:end_at] = params[:end_at].to_time
    # binding.pry
    if @score.save
      render :json => { message: "更新に成功しました。" }
    else
      render :json => { message: "更新に失敗しました。" }
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
    def set_score
      @score = Score.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:user_id, :store_id, :model, :seat, :start_at, :end_at, :investment, :proceeds)
    end
end
