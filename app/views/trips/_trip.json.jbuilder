json.extract! trip, :id, :user_id, :departure_station, :arrival_station, :from_date, :to_date, :searching, :created_at, :updated_at
json.url trip_url(trip, format: :json)
