class ApiController < ApplicationController
  # GET /api/trips
  def stations
    render json: TrainStationService.search(api_params['q'])
  end

  private

  def api_params
    params.permit(:q)
  end
end
