class Sam
  include HTTParty
  base_uri 'api.data.gov'
  http_proxy ENV["HTTP_PROXY_HOST"], ENV["HTTP_PROXY_PORT"], ENV["HTTP_PROXY_USER"], ENV["HTTP_PROXY_PASSWORD"] if ENV["HTTP_PROXY_HOST"]

  def self.get_info(duns)
    duns = duns + "0000" if duns.size == 9
    response = get "/sam/v4/registrations/#{duns}", query: { api_key: ENV["SAM_API_KEY"] }

    sam_data = response.parsed_response["sam_data"]
    return {} unless sam_data

    registration = sam_data["registration"]
    sam_address = registration["samAddress"]

    {
      name: registration["legalBusinessName"],
      address: sam_address["line1"],
      city: sam_address["city"],
      zip: sam_address["zip"],
      state: sam_address["stateorProvince"],
      country: sam_address["countryCode"]
    }
  end
end
