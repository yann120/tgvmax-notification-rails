class ApiController < ApplicationController
  def stations
    stations = TrainStation.new()
  end
end
