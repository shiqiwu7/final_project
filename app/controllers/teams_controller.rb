class TeamsController < ApplicationController
  before_action :authorize_player, except: [ :index, :show ]
  before_action :set_team, only: [ :show, :edit, :update, :destroy, :join, :leave ]
  before_action :authorize_team_owner, only: [ :edit, :update, :destroy ]

  def index
    @teams = Team.all.order(:name)
  end

  def show
    @members = @team.members
  end
  def new
    @team = Team.new
  end

  def create
    @player = current_user.player

    @team = Team.new(team_params.except(:player_ids))
    @team.player = @player

    player_ids = params[:team][:player_ids].reject(&:blank?).map(&:to_i)

    Team.transaction do
      if @team.save
        @team.team_players.create!(player: @player, role: "owner")

        player_ids.each do |player_id|
          next if player_id == @player.id
          @team.team_players.create!(player_id: player_id, role: "member")
        end

        redirect_to @team, notice: "Team was successfully created."
        return
      else
        raise ActiveRecord::Rollback
      end
    end

    @players = Player.all
    flash.now[:alert] = "Failed to create the team: #{@team.errors.full_messages.join(', ')}"
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_path, notice: "Team deleted successfully"
  end

  def join
    @team = Team.find_by(id: params[:id])

    unless @team
      redirect_to teams_path, alert: "Team not found."
      return
    end

    if current_user.player.member_of?(@team)
      redirect_to @team, alert: "You are already a member of this team."
    else
      if @team.add_member(current_user.player)
        redirect_to @team, notice: "You have joined the team successfully."
      else
        redirect_to @team, alert: "Unable to join the team."
      end
    end
  end

  def leave
    @team = Team.find_by(id: params[:id])

    unless @team
      redirect_to teams_path, alert: "Team not found."
      return
    end

    if @team.owner == current_user.player
      redirect_to @team, alert: "As the team owner, you cannot leave the team."
    elsif current_user.player.member_of?(@team)
      if @team.remove_member(current_user.player)
        redirect_to @team, notice: "You have left the team successfully."
      else
        redirect_to @team, alert: "Unable to leave the team."
      end
    else
      redirect_to @team, alert: "You are not a member of this team."
    end
  end


  private

  def set_player
    @player = Player.find(params[:player_id])
  end

  private

  # def set_team
  #   @team = Team.find(params[:id])
  # end

  def set_team
    @team = Team.find_by(id: params[:id])
    unless @team
      redirect_to teams_path, alert: "Team not found."
    end
  end

  def team_params
    params.require(:team).permit(:name, :description, player_ids: [])
  end

  def authorize_team_owner
    unless @team.player == current_user.player
      redirect_to @team, alert: "You are not authorized to perform this action"
    end
  end
end
