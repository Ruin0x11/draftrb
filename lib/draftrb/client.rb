require "faraday"
require "faraday_middleware"

class Draftrb::Client
  DRAFT_URL = "https://draftin.com/api/v1"

  def initialize(email, password)
    @email = email
    @password = password

    @conn = Faraday.new(url: DRAFT_URL) do |faraday|
      faraday.request :json
      faraday.request :basic_auth, email, password
      faraday.response :json, content_type: "application/json"
      faraday.headers["Accept"] = "application/json"

      faraday.use Faraday::Request::Retry
      faraday.use Faraday::Response::Logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def documents(page=1)
    @conn.get "documents.json", { page: page }
  end
end
