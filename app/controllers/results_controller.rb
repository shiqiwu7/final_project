class ResultsController < ApplicationController
  before_action :set_event
  before_action :authorize_event_owner
  before_action :set_result, only: [ :edit, :update, :destroy ]

  def new
    @result = Result.new(event: @event)
    @teams = @event.teams.where(participations: { status: "approved" })
  end

  def create
    @result = Result.new(result_params.merge(event: @event))

    if @result.save
      redirect_to @event, notice: "Result recorded successfully"
    else
      @teams = @event.teams.where(participations: { status: "approved" })
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @teams = @event.teams.where(participations: { status: "approved" })
  end

  def update
    if @result.update(result_params)
      redirect_to @event, notice: "Result updated successfully"
    else
      @teams = @event.teams.where(participations: { status: "approved" })
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @result.destroy
    redirect_to @event, notice: "Result deleted successfully"
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_result
    @result = @event.result
  end

  def result_params
    params.require(:result).permit(:winner_team_id, :score, :details)
  end

  def authorize_event_owner
    unless @event.organizer == current_user.organizer
      redirect_to @event, alert: "You are not authorized to perform this action"
    end
  end
end
