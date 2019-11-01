class Trip < ApplicationRecord
  belongs_to :user
  attr_accessor :from_time, :to_time, :departure_date
  validates :from_time, presence: true
  validates :to_time, presence: true
  validates :departure_date, presence: true
  validates :departure_station, presence: true
  validates :arrival_station, presence: true
  validate :stations_exists
  validate :check_dates
  before_create :set_dates
  before_update :set_dates

  def set_dates
    from_date = create_date(departure_date, from_time)
    to_date = create_date(departure_date, to_time)
    write_attribute(:from_date, from_date)
    write_attribute(:to_date, to_date)
  end

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
    return if from_time.nil? || to_time.nil? || departure_date.nil?
    if create_date(departure_date, from_time) > create_date(departure_date, to_time)
      errors.add(:from_time, "- the from date must finish after the from date")
    end
  end

  private

  def create_date(date, time)
    DateTime.new(date[1],date[2],date[3],time[4],time[5])
  end
end
