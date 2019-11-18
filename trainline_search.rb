ENV['RAILS_ENV'] = "development"
require './config/environment.rb'

class TrainlineSearch

  def search_loop
    while 1 do
      trips_to_search.each do |trip_to_search|
        next if trip_is_outdated?(trip_to_search)
        puts Time.now.strftime("%H:%M") + " Recherche d'un train de #{trip_to_search["departure_station"]} a #{trip_to_search["arrival_station"]} entre le #{trip_to_search["from_date"]} et #{trip_to_search["to_date"]}"
        csv_result = trainline_query(trip_to_search)
        search_results = csv_to_array(csv_result)
        if tgvmax_train = tgvmax_inside?(search_results)
          new_tgvmax_available(tgvmax_train)
        else
					puts Time.now.strftime("%H:%M") + " Aucun train dispo de #{trip_to_search["departure_station"]} a #{trip_to_search["arrival_station"]} entre le #{trip_to_search["from_date"]} et #{trip_to_search["to_date"]}"
        end
      end
    end
  end

  def trainline_query(requested_trip)
    birthdate = format_birthdate(requested_trip.user.birthdate)
    tgvmax_key = requested_trip.user.tgvmax_key
    departure_station = requested_trip['departure_station']
    arrival_station = requested_trip['arrival_station']
    from_date = format_departure_date(requested_trip['from_date'])
    to_date = format_departure_date(requested_trip['to_date'])

    query = "python3 trainline_parser.py \'#{birthdate}\' \'#{tgvmax_key}\' \'#{departure_station}\' \'#{arrival_station}\' \'#{from_date}\' \'#{to_date}\'"
    puts query
    `#{query}`
  end

  def desactivate_searching(trip)
    trip.searching = false
    trip.save
  end

  private

  def trip_is_outdated?(trip)
    if Date.today > Date.parse(trip['to_date'])
      desactivate_searching(trip)
      return true
    end
    return false
  end



  def new_tgvmax_available(train)
    p "Le train suivant est disponible : ", train
  end

  def trips_to_search
    Trip.all.where(searching: true)
  end

  def format_birthdate(birthdate)
    birthdate.strftime('%d/%m/%Y')
  end

  def format_departure_date(date)
    date.strftime('%d/%m/%Y %H:%M')
  end

  def csv_to_array(string)
    string = string.chomp
    string = string.gsub(';', ',')
    csv = CSV::parse(string)
    fields = csv.shift
    fields = fields.map {|f| f.downcase.gsub(" ", "_")}
    csv.collect { |record| Hash[*fields.zip(record).flatten ] }
  end

  def tgvmax_inside?(trips)
    trips.each do |trip|
      return trip if trip["price"] == "0"
    end
    return false
  end
end

search = TrainlineSearch.new
puts search.desactivate_searching(Trip.last)
