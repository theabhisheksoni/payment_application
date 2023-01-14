module Api
  module V1
    class AccountsController < ApplicationController
      skip_before_action :verify_authenticity_token

      include ResponseHandler
      include ExceptionHandler

      def authenticate
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          token = JwtTokenService.encode(user_id: user.id)
          json_response({ access_token: token }, 201)
        else
          json_response({ error: 'Unauthorized' }, :unauthorized)
        end
      end
    end
  end
end
