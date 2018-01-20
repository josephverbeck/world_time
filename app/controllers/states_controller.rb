class StatesController < ApplicationController

  def create
    @country = Country.find(params[:country_id])
    @state = @country.states.create!(state_params[:state])
    redirect_to @country, :notice => "State added."
  end

  def new
    @country = Country.find(state_params[:country_id])
    if(@country.blank?)
      @country = Country.new({:name => country_params[:country_id]})
    end
    @state = @country.states.create!({:name => state_params[:state][:state_name]})
    return redirect_to country_path(state_params[:country_id])
  end

  private
  def state_params
    params.permit(:country_id, :state => {})
  end

end
