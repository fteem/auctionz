GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end

GrapeSwaggerRails.options.app_name = 'Auctionz'
GrapeSwaggerRails.options.url = '/api/doc/v1.json'
GrapeSwaggerRails.options.doc_expansion = 'list'
GrapeSwaggerRails.options.api_key_name = 'user_token'
GrapeSwaggerRails.options.api_key_type = 'query'
