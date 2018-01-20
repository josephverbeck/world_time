json.extract! country, :id, :name, :created_at, :updated_at
json.url country_url(country, format: :json)
json.extract! state, :id, :name, :latitude, :longitude, :created_at, :updated_at
json.url state_url(state, format: :json)