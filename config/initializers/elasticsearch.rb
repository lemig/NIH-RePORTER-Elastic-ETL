# change me
host ='https://admin:password@127.0.0.1:9220'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: host,
  transport_options: { proxy: "" },
  log: false
)

$es = Elasticsearch::Model.client

$es_settings = JSON.parse(File.read("#{Rails.root}/config/es_settings.json"))
