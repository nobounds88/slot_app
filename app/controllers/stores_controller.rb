class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy, :saved_balls_ajax]
  # before_action :set_store_user, only: [:saved_balls_ajax]
  before_action :authenticate_user!

  # GET /stores
  # GET /stores.json'
  def index
    @search_params ||= {}
    @search_params[:keyword] = params[:keyword]
    
    @stores = Store.all
    if params[:keyword].present?
      @stores = @stores.where("(name||' '||ifnull(name_kana, '')||' '||ifnull(area, '')||' '||ifnull(address,'')) like ?", "%#{params[:keyword]}%")
    end
  end
  
  # GET /stores/1
  # GET /stores/1.json
  def show
  end
  
  # GET /stores/new
  def new
    @store = Store.new
    @store.latitude = 35.7
    @store.longitude = 139.7
  end
  
  # GET /stores/1/edit
  def edit
  end
  
  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)
  
    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: t(:was_successfully_created) }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: t(:was_successfully_updated) }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def saved_balls_ajax
    store = Store.find_by(id: params[:store_id])
    # binding.pry
    s = store.store_users.new(store: store, saved_balls: params[:saved_balls])
    s[:user_id] = params[:user_id].to_i
    
    if store.save
      render :json => { message: "更新に成功しました。" }
    else
      render :json => { message: "更新に失敗しました。" }
    end
  end
  
  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:name, :name_kana, :area, :address, :latitude, :longitude)
    end
end
