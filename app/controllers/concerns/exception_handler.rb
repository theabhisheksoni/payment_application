module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    ActionController::Parameters.action_on_unpermitted_parameters = :raise

    rescue_from ActionController::UnpermittedParameters do |e|
      json_response({
                      message: "Unpermitted parameters received: #{e.params}"
                    }, :unprocessable_entity)
    end

    rescue_from ActionController::ParameterMissing do |e|
      json_response({
                      message: "Required parameter missing: #{e.param}"
                    }, :unprocessable_entity)
    end

    rescue_from ArgumentError do |e|
      json_response({
                      message: "Invalid parameter: #{e}"
                    }, :unprocessable_entity)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
