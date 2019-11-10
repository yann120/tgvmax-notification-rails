module TripsHelper
  def searching_background_color(trip)
    'has-background-success' if trip.searching
  end
end
