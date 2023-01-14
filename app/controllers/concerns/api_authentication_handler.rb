module ApiAuthenticationHandler
  extend ActiveSupport::Concern
  include ResponseHandler
  include ExceptionHandler

  def authenticate_api_request!
    return if request.headers['Authorization'].blank?

    token = request.headers['Authorization'].split(' ').last
    begin
      response = JwtTokenService.decode(token)
      user = User.find_by(id: response&.first&.[]('user_id'))
      sign_in user if user.present?
    rescue JWT::ExpiredSignature => e
      json_response({ error: e.message }, 401)
    end
  end
end
