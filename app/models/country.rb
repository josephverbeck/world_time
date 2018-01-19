class Country
  include Mongoid::Document
  field :name, type: String
  field :country_code, type: String
  field :full_address, type: String
  field :country, type: String
  field :day_light_savings, type: Boolean
  field :lat, type: Float
  field :long, type: Float

  embeds_many :states

  before_create :set_fields

  def set_fields
    location = Geokit::Geocoders::GoogleGeocoder.geocode(name.to_s)
    self.full_address ||= location.full_address
    self.country ||= location.country
    self.country_code ||= location.country_code
    self.lat, self.long = location.ll.split(",")
    self.day_light_savings = Timezone.lookup(self.lat, self.long).dst?(Time.now)
  end


  private
  def state_params
    params.permit(:name, :lat, :long)
  end
end
