module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate!

      private

      def authenticate!
        head :unauthorized unless current_team
      end

      def current_team
        return @current_team if defined?(@current_team)

        public_key = request.headers["X-Team-Public-Key"].to_s
        secret_key = request.headers["X-Team-Secret-Key"].to_s

        team = Team.find_by(public_key: public_key)
        @current_team = team&.authenticate_secret_key(secret_key)
      end
    end
  end
end
