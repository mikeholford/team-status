class TeamUsersController < ApplicationController
  def create
    team = Team.find_by!(uuid: params[:team_uuid])
    team_user = team.team_users.new(team_user_params)

    if team_user.save
      redirect_to team_path(team), status: :see_other
    else
      @team = team
      @team_user = team_user
      render "teams/show", status: :unprocessable_entity
    end
  end

  private

  def team_user_params
    params.require(:team_user).permit(:username, :profile_pic_url)
  end
end
