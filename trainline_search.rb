ENV['RAILS_ENV'] = "development"
require './config/environment.rb'

class TrainlineSearch

  def search_loop
    while 1 do
      trips_to_search.each do |trip_to_search|
        next unless trip_is_valid?(trip_to_search)
        next if trip_is_outdated?(trip_to_search)
        puts Time.now.strftime("%H:%M") + " Recherche d'un train de #{trip_to_search["departure_station"]} a #{trip_to_search["arrival_station"]} entre le #{trip_to_search["from_date"]} et #{trip_to_search["to_date"]}"
        csv_result = trainline_query(trip_to_search)
        search_results = csv_to_array(csv_result)
        if tgvmax_train = tgvmax_inside?(search_results)
          new_tgvmax_available(trip_to_search, tgvmax_train)
        else
					puts Time.now.strftime("%H:%M") + " Aucun train dispo de #{trip_to_search["departure_station"]} a #{trip_to_search["arrival_station"]} entre le #{trip_to_search["from_date"]} et #{trip_to_search["to_date"]}"
        end
        sleep(5)
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
    trip.save(validate: false)
  end

  def trip_is_valid?(trip)
    return false unless (trip.departure_station.is_a? String || trip.departure_station.to_s.strip.empty?)
    return false unless (trip.arrival_station.is_a? String || trip.arrival_station.to_s.strip.empty?)
    return false if trip.from_date.nil?
    return false if trip.to_date.nil?
    return false if trip.user.tgvmax_key.nil?
    return false if trip.user.birthdate.nil?

    # Notify the user if false
    true
  end

  private

  def trainline_date_generator(departure_date)
    temp_time = Time.parse(departure_date)
    temp_time.strftime("%Y-%m-%d-%H:%M")
  end

  def trainline_url_generator(trip, train)
    departure_station = trip.departure_station
    arrival_station = trip.arrival_station
    tl_departure_date = trainline_date_generator(train['departure_date'])
    url = "https://www.trainline.fr/search/#{departure_station}/#{arrival_station}/#{tl_departure_date}"
    ShortURL.shorten(url)
  end

  def notify_user(trip, train)
    Mailjet.configure do |config|
      config.api_key = ENV['MJ_APIKEY_PUBLIC']
      config.secret_key = ENV['MJ_APIKEY_PRIVATE']
      config.api_version = "v3.1"
    end
    variable = Mailjet::Send.create(messages: [{
      'From'=> {
        'Email'=> "yann.petitjean06@gmail.com",
        'Name'=> "TGVMAX"
      },
      'To'=> [
        {
          'Email'=> trip.user.email,
          'Name'=> "Passager TGVMAX"
        }
      ],
      'TemplateID'=> 1092935,
      'TemplateLanguage'=> true,
      'Subject'=> "TGVMAX Disponible ",
      'Variables'=> {
        "departure_station" => trip.departure_station,
        "arrival_station" => trip.arrival_station,
        "departure_date" => train['departure_date'],
        "url" => trainline_url_generator(trip, train)
      }
    }])
    p variable.attributes['Messages']
  end

  def trip_is_outdated?(trip)
    if Date.today > trip['to_date']
      # Notify the user
      puts trip, "is outdated"
      desactivate_searching(trip)
      return true
    end
    false
  end

  def new_tgvmax_available(trip, train)
    puts 'Le train suivant est disponible : ', train
    notify_user(trip, train)
    desactivate_searching(trip)
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
    csv.collect { |record| Hash[*fields.zip(record).flatten] }
  end

  def tgvmax_inside?(trips)
    trips.each do |trip|
      return trip if trip["price"] == "0"
    end
    false
  end
end

search = TrainlineSearch.new
puts "La recherche va commencer"
search.search_loop
