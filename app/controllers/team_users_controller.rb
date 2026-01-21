class TeamUsersController < ApplicationController
  def show
    @team = Team.find_by!(uuid: params[:team_uuid])
    @team_user = @team.team_users.find(params[:id])

    page = params.fetch(:page, 1).to_i
    page = 1 if page < 1
    @page = page
    @per_page = 50

    @status_updates = @team_user.status_updates
      .order(created_at: :desc)
      .limit(@per_page)
      .offset((@page - 1) * @per_page)

    @has_more = @team_user.status_updates.count > (@page * @per_page)
  end

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
