class UsersController < ApplicationController
  before_action :authenticate_user!, :except=>[:show]
  
  def index
    @search_params ||= {}
    @search_params[:keyword] = params[:keyword]
    
    @users = User.all
    if params[:keyword].present?
      @users = @users.where("(name||' '||ifnull(gender, '')||' '||ifnull(email,'')) like ?", "%#{params[:keyword]}%")
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
end
