class Trip < ApplicationRecord
  belongs_to :user
  attr_writer :from_time, :to_time, :departure_date
  validates :from_time, presence: true
  validates :to_time, presence: true
  validates :departure_station, presence: true
  validates :arrival_station, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true
  validate :departure_station_existance, :arrival_station_existance
  validate :check_dates

  def save_dates
    from_date = create_date(departure_date, from_time)
    to_date = create_date(departure_date, to_time)
    write_attribute(:from_date, from_date)
    write_attribute(:to_date, to_date)
  end

  def departure_date
    from_date&.strftime('%d/%m/%Y')
  end

  def from_time
    from_date
  end

  def to_time
    to_date
  end

  def departure_station_existance
    return if TrainStationService.station_exists?(departure_station)

    errors.add(:departure_station, "- #{departure_station} is not a valid departure station")
  end

  def arrival_station_existance
    return if TrainStationService.station_exists?(arrival_station)

    errors.add(:arrival_station, "- #{arrival_station} is not a valid arrival station")
  end

  def check_dates
    return if from_date.nil? || to_date.nil? || departure_date.nil?

    if from_date > to_date
      errors.add(:from_time, '- the from date must finish after the from date')
    elsif from_date == to_date
      errors.add(:to_time, '- To time must be after from time')
    end
  end

  def create_date(date, time)
    d = Date.strptime(date, '%d/%m/%Y')
    DateTime.new(d.year, d.month, d.day, time[3].to_i, time[4].to_i)
  end
end
