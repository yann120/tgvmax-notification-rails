class Trip < ApplicationRecord
  belongs_to :user
  validate :stations_exists
  validate :check_dates

  def stations_exists
    @trainstation = TrainStation.new()
    if (@trainstation.verify_station(departure_station) === false)
      errors.add(:departure_station, "- #{departure_station} is not a valid departure station")
    end
    if (@trainstation.verify_station(arrival_station) === false)
      errors.add(:arrival_station, "- #{arrival_station} is not a valid arrival station")
    end
  end

  def check_dates
    if (from_date > to_date)
      errors.add(:from_date, "- the from date must finish after the from date")
    end
  end
end
