require "application_system_test_case"

class TripsTest < ApplicationSystemTestCase
  setup do
    @trip = trips(:one)
  end

  test "visiting the index" do
    visit trips_url
    assert_selector "h1", text: "Trips"
  end

  test "creating a Trip" do
    visit trips_url
    click_on "New Trip"

    fill_in "Arrival station", with: @trip.arrival_station
    fill_in "Departure station", with: @trip.departure_station
    fill_in "From date", with: @trip.from_date
    check "Searching" if @trip.searching
    fill_in "To date", with: @trip.to_date
    fill_in "User", with: @trip.user_id
    click_on "Create Trip"

    assert_text "Trip was successfully created"
    click_on "Back"
  end

  test "updating a Trip" do
    visit trips_url
    click_on "Edit", match: :first

    fill_in "Arrival station", with: @trip.arrival_station
    fill_in "Departure station", with: @trip.departure_station
    fill_in "From date", with: @trip.from_date
    check "Searching" if @trip.searching
    fill_in "To date", with: @trip.to_date
    fill_in "User", with: @trip.user_id
    click_on "Update Trip"

    assert_text "Trip was successfully updated"
    click_on "Back"
  end

  test "destroying a Trip" do
    visit trips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trip was successfully destroyed"
  end
end
