module Api
  module V1
    class TeamUsersController < BaseController
      def index
        users = current_team.team_users.order(:username)

        render json: {
          team: { uuid: current_team.uuid, name: current_team.name },
          users: users.map { |u| user_json(u) }
        }
      end

      def create
        user = current_team.team_users.new(team_user_params)

        if user.save
          render json: { user: user_json(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def team_user_params
        params.require(:team_user).permit(:username, :profile_pic_url)
      end

      def user_json(user)
        {
          id: user.id,
          username: user.username,
          profile_pic_url: user.profile_pic_url
        }
      end
    end
  end
end
