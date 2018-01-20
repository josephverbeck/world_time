class AddressesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  # GET /countries.json
  def index
    @countries = Address.distinct(:country)
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
    # @country = Address.where(:country => )
    addresses = Address.where(:country => params[:id])
    @states = {}
    addresses.each do | address |
      @states[address.full_address] = {
          :lat => address.lat,
          :long => address.long,
          :dst => address.day_light_savings,
          :tz => Timezone[address.timezone].utc_to_local(Time.now)
      }
    end
    # @country.states.each do | state |
    #   @states[state.state_name] = {
    #       :lat => state.lat,
    #       :long => state.long,
    #       :dst => @country.day_light_savings,
    #       :tz => Timezone[state.timezone].utc_to_local(Time.now)
    #   }
    # end
    gon.states = @states
  end

  # GET /countries/new
  def new
    address = Address.where(:_id => country_params[:country]).first
    if(address.blank?)
      Address.new({:name => country_params[:country]}).save!
      newAddress = Address.where(:_id => country_params[:country]).first
      Address.new({:name => newAddress.country}).save!
      @country = Address.where(:_id => newAddress.country).first
    else
      @country = Address.where(:_id => address.country).first
    end
    respond_to do |format|
      if true
        format.html { redirect_to address_path(@country), notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :show }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /countries/1/edit
  def edit
  end

  # POST /countries
  # POST /countries.json
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

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
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

  # DELETE /countries/1
  # DELETE /countries/1.json
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
