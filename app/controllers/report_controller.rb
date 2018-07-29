class ReportController < ApplicationController
  before_action :authenticate_user!

  def index
    # SELECT
    #   strftime('%Y-%m-%d', start_at) AS target_date,
    #   SUM(proceeds) AS proceeds_summary,
    #   SUM(investment) AS investment_summary
    # FROM scores
    # WHERE ....
    # GROUP BY strftime('%Y-%m-%d', start_at);
    relation = search
    if search.blank?
      @scores = []
    else
      relation = relation.group("strftime('%Y-%m-%d', start_at)")
      relation = relation.select([
        "strftime('%Y-%m-%d', start_at) AS target_date",
        "SUM(proceeds) AS proceeds_summary",
        "SUM(investment) AS investment_summary",
      ].join(','))

      @scores = relation.order("target_date")
      @chart_data = [
        { name: 'investment', data: [] },
        { name: 'proceeds', data: [] }
      ]

      @scores.each do |score|
        @chart_data[0][:data] << [
          score.target_date , score.investment_summary
        ]
        @chart_data[1][:data] << [
          score.target_date , score.proceeds_summary
        ]
      end
    end
  end

  def day_of_the_week_chart
    # 曜日（0=Sunday..6=Saturday）
    # SELECT
    #   strftime('%w', start_at) AS target_date,
    #   SUM(proceeds - investment) AS score_summary,
    # FROM scores
    # WHERE ....
    # GROUP BY strftime('%w', start_at);
    relation = search
    if search.blank?
      @scores = []
    else
      relation = relation.group("strftime('%w', start_at)")
      relation = relation.select([
        "strftime('%w', start_at) AS target_date",
        "SUM(proceeds - investment)/COUNT(proceeds) AS score_summary",
      ].join(','))

      @scores = relation.order("target_date")
      @scores = relation
      @chart_data = []
      @scores.each do |score|
        @chart_data << [
          t('date.abbr_day_names')[score.target_date.to_i] , score.score_summary
        ]
      end
    end
  end

  def model_chart
    relation = search
    if search.blank?
      @scores = []
    else
      relation = relation.group(:model)
      relation = relation.select([
        :model,
        "SUM(proceeds - investment) AS score_summary",
      ].join(','))

      @scores = relation.order("score_summary DESC")
      # @scores = relation.order("SUM(proceeds - investment) DESC")

      @chart_data = []

      @scores.each do |score|
        @chart_data << [
          score.model , score.score_summary
        ]
      end
    end
  end

  def search
    @search_params ||= {}
    @search_params[:id] = params[:id]
    @search_params[:user_id] = params[:user_id]
    @search_params[:model] = params[:model]
    @search_params[:store_id] = params[:store_id]
    @search_params[:play_start] = params[:play_start]
    @search_params[:play_end] = params[:play_end]
    @win_or_lose = params[:win_or_lose]

    return nil if @search_params[:play_start].blank? and @search_params[:play_end].blank?

    relation = Score.all
    relation = relation.where( id: @search_params[:id] ) if @search_params[:id].present?
    relation = relation.where( user_id: current_user.id )
    relation = relation.where( "model like ?", "%" + @search_params[:model] + "%" ) if @search_params[:model].present?
    relation = relation.where( store_id: @search_params[:store_id] ) if @search_params[:store_id].present?
    relation = relation.where( "start_at >= ?", @search_params[:play_start].to_datetime ) if @search_params[:play_start].present?
    relation = relation.where( "end_at < ?", @search_params[:play_end].to_datetime.tomorrow ) if @search_params[:play_end].present?

    case @win_or_lose.to_i
    when 1 then
      relation = relation.where("proceeds - investment > 0")
    when 2 then
      relation = relation.where("proceeds - investment < 0")
    when 3 then
      relation = relation.where("proceeds - investment == 0")
    end
    return relation
  end
end
