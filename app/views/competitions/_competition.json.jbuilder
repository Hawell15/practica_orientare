json.extract! competition, :id, :competition_name, :date, :location, :country, :distance_type, :created_at, :updated_at
json.url competition_url(competition, format: :json)
