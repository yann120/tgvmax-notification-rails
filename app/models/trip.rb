class Trip < ApplicationRecord
  belongs_to :user
  validate :stations_exists

  def stations_exists
    @trainstation = TrainStation.new()
    if (@trainstation.verify_station(departure_station) === false)
      errors.add(:departure_station, "- #{departure_station} is not a valid departure station")
    end
    if (@trainstation.verify_station(arrival_station) === false)
      errors.add(:arrival_station, "- #{arrival_station} is not a valid arrival station")
    end
  end
end
