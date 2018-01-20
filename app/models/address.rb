class Address
  include Mongoid::Document
  field :name, type: String
  field :country_code, type: String
  field :full_address, type: String
  field :country, type: String
  field :day_light_savings, type: Boolean
  field :lat, type: Float
  field :long, type: Float
  field :name, type: String
  field :street_number, type: String
  field :street_name, type: String
  field :city, type: String
  field :district, type: String
  field :zip, type: String
  field :state, type: String
  field :state_code, type: String
  field :state_name, type: String
  field :timezone, type: String
  field :_id, type: String, default: ->{ name }
  field :user_search, type: Array

  before_create :set_fields

  def set_fields
    location = Geokit::Geocoders::GoogleGeocoder.geocode(name.to_s)
    self.full_address ||= location.full_address
    self.name = location.country
    self.country ||= location.country
    self.country_code ||= location.country_code
    self.lat, self.long = location.ll.split(",")
    self.day_light_savings ||= Timezone.lookup(self.lat, self.long).dst?(Time.now)
    self.street_number ||= location.street_number
    self.street_name ||= location.street_name
    self.city ||= location.city
    self.district ||= location.district
    self.zip ||= location.zip
    self.state ||= location.state
    self.state_code ||= location.state_code
    self.state_name ||= location.state_name
    self.timezone ||= Timezone.lookup(self.lat, self.long).name
  end


  private
  def state_params
    params.permit(:name, :lat, :long)
  end
end
