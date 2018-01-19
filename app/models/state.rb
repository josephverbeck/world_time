class State
  include Mongoid::Document
  field :name, type: String
  field :full_address, type: String
  field :street_number, type: String
  field :street_name, type: String
  field :city, type: String
  field :district, type: String
  field :country, type: String
  field :zip, type: String
  field :state, type: String
  field :state_code, type: String
  field :state_name, type: String
  field :lat, type: Float
  field :long, type: Float
  field :timezone, type: String
  field :_id, type: String, default: ->{ name }

  before_create :set_lat_and_long

  embedded_in :country, :inverse_of => :states

  def set_lat_and_long
    location = Geokit::Geocoders::GoogleGeocoder.geocode(name.to_s)
    self.full_address ||= location.full_address
    self.street_number ||= location.street_number
    self.street_name ||= location.street_name
    self.city ||= location.city
    self.district ||= location.district
    self.country ||= location.country
    self.zip ||= location.zip
    self.state ||= location.state
    self.state_code ||= location.state_code
    self.state_name ||= location.state_name
    self.lat, self.long = location.ll.split(",")
    self.timezone = Timezone.lookup(self.lat, self.long).name
  end

end
