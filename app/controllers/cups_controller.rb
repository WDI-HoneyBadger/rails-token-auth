class CupsController < ApplicationController

  def index 
    @cups = Cup.all 
    render json: @cups
  end 

end
