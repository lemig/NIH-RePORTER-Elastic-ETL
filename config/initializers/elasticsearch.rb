scheme   = ENV['ES_SCHEME']   || 'http'
user     = ENV['ES_USER']
password = ENV['ES_PASSWORD']
host     = ENV['ES_HOST']     || '127.0.0.1'
port     = ENV['ES_PORT']     || '9200'
ca_file  = ENV['ES_CA_FILE_PATH']

if Rails.env == "remote"
  password = ENV['ES_REMOTE_PASSWORD']
  port     = ENV['ES_REMOTE_PORT']
end

transport_options = nil                       unless ca_file
transport_options = { ssl: { ca_file: ca_file } } if ca_file

Elasticsearch::Model.client = Elasticsearch::Client.new(
  scheme: scheme,
  user: user,
  password: password,
  host: host,
  port: port,
  request_timeout: 120,
  transport_options: transport_options
)

$es = Elasticsearch::Model.client

$es_settings = JSON.parse(File.read("#{Rails.root}/config/es_settings.json"))
