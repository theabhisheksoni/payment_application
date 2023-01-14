module Helpers
  def json_response(response)
    JSON.parse(response.body)
  end
end
