class TeamsController < ApplicationController
  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.name = "My Team" if @team.name.blank?

    if @team.save
      flash[:team_secret_key] = @team.secret_key
      redirect_to team_path(@team), status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @team = Team.includes(team_users: :status_updates).find_by!(uuid: params[:uuid])
    @team_user = @team.team_users.new
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
