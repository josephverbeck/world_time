class AddressesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  def index
    @countries = Address.distinct(:country)
  end

  def show
    @addresses = Address.where(:country => params[:id]).in(:user_search => [current_user.id.to_s])
    @states = {}
    @addresses.each do | address |
      @states[address.full_address] = {
          :lat => address.lat,
          :long => address.long,
          :dst => address.day_light_savings,
          :tz => Timezone[address.timezone].utc_to_local(Time.now)
      }
    end
    gon.states = @states
  end

  # Rewrite to much going on here! -jv
  def new
    @address = Address.where(:_id => country_params[:country]).first
    if(@address.blank?)
      @address = Address.new({:name => country_params[:country], :user_search => [current_user.id.to_s]})
      @address.save!
    else
      @address.user_search << current_user.id.to_s
      @address.save!
    end
    @country = Address.where(:_id => @address.country).first
    if(@country.blank?)
      @country = Address.new(:name => @address.country)
      @country.save!
    end
    respond_to do |format|
      format.html { redirect_to address_path(@country), notice: 'Address was successfully created.' }
      format.json { render :show, status: :created, location: @country }
    end
  end

  def edit
  end

  def create
    @country = Address.new(country_params)

    respond_to do |format|
      if @country.save
        format.html { redirect_to @country, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :new }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to @country, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Address.where(:_id => params[:id]).first
      if(@country.blank?)
        Address.new({:name => params[:id]}).save!
        @country = Address.where(:_id => params[:id]).first
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.permit(:name, :country)
    end
end
