class ParticipationsController < ApplicationController
  before_action :set_event
  before_action :set_team, only: [ :create ]
  before_action :set_participation, only: [ :update, :destroy ]
  before_action :authorize_team_owner, only: [ :create, :destroy ]
  before_action :authorize_event_owner, only: [ :update ]

  def create
    @participation = Participation.new(
      team: @team,
      event: @event,
      registration_date: Time.current,
      status: "pending"
    )

    if @participation.save
      redirect_to @event, notice: "Team registered for event successfully"
    else
      redirect_to @event, alert: @participation.errors.full_messages.to_sentence
    end
  end

  def update
    if @participation.update(participation_params)
      redirect_to @event, notice: "Registration status updated"
    else
      redirect_to @event, alert: @participation.errors.full_messages.to_sentence
    end
  end

  def destroy
    @participation.destroy
    redirect_to @event, notice: "Team withdrawn from event"
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_team
    @team = Team.find(params[:team_id])
  end

  def set_participation
    @participation = Participation.find(params[:id])
  end

  def participation_params
    params.require(:participation).permit(:status)
  end

  def authorize_team_owner
    unless @team.player == current_user.player
      redirect_to @event, alert: "You are not authorized to perform this action"
    end
  end

  def authorize_event_owner
    unless @event.organizer == current_user.organizer
      redirect_to @event, alert: "You are not authorized to perform this action"
    end
  end
end
