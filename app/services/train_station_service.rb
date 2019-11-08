# frozen_string_literal: true

require 'csv'

class TrainStationService
  class << self
    def search(station)
      results = stations.grep(/#{station}/i).first(15)
      array = []
      results.each do |result|
        array << { 'name' => result }
      end
      array
    end

    def station_exists?(station)
      stations.include?(station)
    end

    private

    def read_train_stations
      stations_list = []
      csv_text = File.read('stations_mini.csv')
      csv = CSV.parse(csv_text, headers: false, col_sep: ';')
      csv.each do |row|
        value = row.last
        stations_list << value
      end
      stations_list
    end

    def stations
      @stations ||= read_train_stations
    end
  end
end
