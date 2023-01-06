module ResponseHandler
  extend ActiveSupport::Concern

  def json_response(object, status = :ok, location = nil)
    if location.nil?
      render json: object, status: status
    else
      render json: object, status: status, location: location
    end
  end
end
