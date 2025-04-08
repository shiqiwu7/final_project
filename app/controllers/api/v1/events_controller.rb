# app/controllers/api/v1/events_controller.rb
class Api::V1::EventsController < Api::V1::BaseController
  before_action :authenticate_jwt
  before_action :authenticate_user!
  before_action :set_event, only: [ :show, :update, :destroy ]

  def index
    @events = Event.all
    # render json: @events
    render json: { events: @events }, status: :ok
  end

  def show
    render json: @event.to_json(include: [ :result, :participations ])
  end

  def create
    # @event = Event.new(event_params)
    @event = current_user.organizer.events.build(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: @event
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_date, :end_date, :location)
  end
end
