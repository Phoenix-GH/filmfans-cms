if Rails.env == "staging"
  ENV["ELASTICSEARCH_URL"] = 'http://192.168.0.4:9200'
end