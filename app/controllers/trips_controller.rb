class TripsController < ApplicationController
  before_action :set_trip, only: %i[show edit update destroy]
  before_action :check_user, only: %i[show edit update destroy]
  before_action :check_tgvmax_key, only: %i[new update]

  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.where(user_id: current_user.id).order('from_date')
  end

  # GET /trips/1
  # GET /trips/1.json
  def show; end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit; end

  # POST /trips
  # POST /trips.json
  def create
    puts 'trip', trip_params
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    @trip.searching = true
    @trip.from_date = from_date
    @trip.to_date = to_date

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    puts 'trip', trip_params
    respond_to do |format|
      @trip.from_date = from_date
      @trip.to_date = to_date
      if @trip.update(trip_params)
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { render :show, status: :ok, location: @trip }
      else
        format.html { render :edit }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, notice: 'Trip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def from_date
    departure_date = trip_params[:departure_date]
    from_time = trip_params.select { |k| k.start_with? 'from_time' }.values
    return if departure_date.nil? || departure_date.empty? || from_time.length != 5

    @trip.create_date(departure_date, from_time)
  end

  def to_date
    departure_date = trip_params[:departure_date]
    to_time = trip_params.select { |k| k.start_with? 'to_time' }.values
    return if departure_date.nil? || departure_date.empty? || to_time.length != 5

    @trip.create_date(departure_date, to_time)
  end

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def check_user
    redirect_to trips_path if current_user != @trip.user
  end

  def trip_params
    params.require(:trip).permit(:user_id, :departure_station, :arrival_station, :from_date, :to_date, :searching,
                                 :from_time, :to_time, :departure_date)
  end

  def check_tgvmax_key
    return if current_user.tgvmax_key_valid?

    redirect_to edit_user_registration_path, flash: { alert: 'You must enter a valid TGVMAX Key' }
  end
end
