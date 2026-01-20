module Api
  module V1
    class StatusesController < BaseController
      def show
        users = current_team.team_users.includes(:status_updates).order(:username)

        render json: {
          team: {
            uuid: current_team.uuid,
            name: current_team.name
          },
          users: users.map { |u| status_json(u) }
        }
      end

      private

      def status_json(user)
        current = user.current_status_update

        {
          username: user.username,
          profile_pic_url: user.profile_pic_url,
          status: current&.status,
          updated_at: current&.created_at
        }
      end
    end
  end
end
