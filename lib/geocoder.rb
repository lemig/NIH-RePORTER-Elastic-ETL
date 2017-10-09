class Geocoder
  include HTTParty
  base_uri 'europa.eu'
  http_proxy ENV["HTTP_PROXY_HOST"], ENV["HTTP_PROXY_PORT"], ENV["HTTP_PROXY_USER"], ENV["HTTP_PROXY_PASSWORD"] if ENV["HTTP_PROXY_HOST"]

  def self.geocode(address)
    return {} if address.blank?
    begin
      response = get "/webtools/rest/geocoding/index.php", query: { address: address }
      coordinates = response.parsed_response["geocodingRequestsCollection"]
                            .first['result']['features']
                            .first['geometry']['coordinates']

      { lat: coordinates.last, lon: coordinates.first }
    rescue
      {}
    end
  end
end
