class ApiController < ApplicationController
  def stations
    stations = TrainStation.new()
    query = api_params['q']
    list = stations.search(query)
    render json: list
  end

  private 

  def api_params
    params.permit(:q)
  end
end
