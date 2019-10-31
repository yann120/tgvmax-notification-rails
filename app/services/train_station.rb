require 'csv'

class TrainStation
    def initialize
        @stations = read_train_stations()
    end

    def search(station)
        result = @stations.grep(/#{station}/i).first(15)
        array = []
        result.each do |station|
            array << {'name' => station}
        end
        array
    end

    def verify_station(station)
        return @stations.include?(station)
    end

    private

    def read_train_stations
        stations_list =  []
        csv_text = File.read('stations_mini.csv')
        csv = CSV.parse(csv_text, headers: false, col_sep: ";")
        csv.each do |row|
            value = row.last
            stations_list << value
        end
        stations_list
    end
end