require 'csv'

class TrainStation
    def initialize
        @stations = read_train_stations()
    end

    def search(station)
        @stations.grep(/#{station}/).first(15)
    end

    private

    def read_train_stations
        stations =  []
        csv_text = File.read('stations_mini.csv')
        csv = CSV.parse(csv_text, headers: false, col_sep: ";")
        csv.each do |row|
            stations << row.last
        end
        stations
    end
end