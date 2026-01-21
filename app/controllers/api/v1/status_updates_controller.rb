module Api
  module V1
    class StatusUpdatesController < BaseController
      def create
        user = current_team.team_users.find_by(username: params[:username].to_s)
        return render json: { error: "user_not_found" }, status: :not_found if user.nil?

        status_update = user.status_updates.new(
          status: params[:status],
          team: current_team,
          expires_at: parse_expires_at
        )

        if status_update.save
          render json: { status_update: status_update_json(status_update) }, status: :created
        else
          render json: { errors: status_update.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def parse_expires_at
        expires = params[:expires].to_s
        return if expires.blank?

        Time.zone.parse(expires)
      end

      def status_update_json(status_update)
        {
          id: status_update.id,
          username: status_update.team_user.username,
          status: status_update.status,
          created_at: status_update.created_at,
          expires_at: status_update.expires_at
        }
      end
    end
  end
end
