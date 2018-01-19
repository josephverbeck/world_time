class StatesController < ApplicationController

  def create
    @country = Country.find(params[:country_id])
    p "here"
    p params
    p state_params[:state]
    @state = @country.states.create!(state_params[:state])
    redirect_to @country, :notice => "State added."
  end

  private
  def state_params
    params.permit(:state => {})
  end

end
