class CupsController < ApplicationController
  before_action :require_token
  def index 
    @cups = @current_user.cups
    render json: @cups
  end 
end
