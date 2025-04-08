class Api::V1::TeamsController < Api::V1::BaseController
  before_action :set_team, only: [ :show, :update, :destroy, :join, :leave ]

  def index
    @teams = Team.all
    render json: @teams
  end

  def show
    render json: @team
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      render json: @team, status: :created
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: { errors: @team.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @team.destroy
    head :no_content
  end

  def join
    @team = Team.find_by(id: params[:id])
    return render json: { error: "Team not found" }, status: :not_found unless @team

    player = current_user.player

    existing = TeamPlayer.find_by(team: @team, player: player)
    if existing
      return render json: { error: "You are already a member of this team." }, status: :unprocessable_entity
    end

    membership = TeamPlayer.new(team: @team, player: player, role: "member")

    if membership.save
      render json: { message: "Successfully joined the team" }, status: :ok
    else
      render json: { errors: membership.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def leave
    membership = TeamPlayer.find_by(team: @team, player: current_user.player)

    if membership&.destroy
      render json: { message: "Successfully left the team" }, status: :ok
    else

      render json: { error: "Membership not found" }, status: :not_found
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
