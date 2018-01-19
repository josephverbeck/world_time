class StatesController < ApplicationController

  def create
    @country = Country.find(params[:country_id])
    @state = @country.states.create!(state_params[:state])
    redirect_to @country, :notice => "State added."
  end

  private
  def state_params
    params.permit(:state => {})
  end

end
