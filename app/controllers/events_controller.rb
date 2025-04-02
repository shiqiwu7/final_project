class EventsController < ApplicationController
  before_action :authorize_organizer, except: [ :index, :show ]
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_event_owner, only: [ :edit, :update, :destroy ]

  def index
    @events = Event.all
  end

  def show
    @teams = @event.teams
    @result = @event.result
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.organizer.events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event deleted successfully"
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_date, :end_date, :location)
  end

  def authorize_event_owner
    unless @event.organizer == current_user.organizer
      redirect_to @event, alert: "You are not authorized to perform this action"
    end
  end
end
