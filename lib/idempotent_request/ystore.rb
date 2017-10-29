require 'yaml/store'

module IdempotentRequest
  class YStore
    IDEMPOTENCY_HEADER = 'HTTP_IDEMPOTENCY_KEY'.freeze
    STORE_FILE_PATH    = 'idempotency_keys.store'.freeze

    attr_reader :store

    def initialize app
      @app = app
      @store = YAML::Store.new(Rails.root.join(STORE_FILE_PATH))
    end

    def call env
      dup._call env
    end

    def _call env
      idempotency_key = env[IDEMPOTENCY_HEADER]

      if idempotency_key.present?
        action = store.transaction(false) { store[idempotency_key] }

        if action.present?
          status = action[:status]
          headers = action[:headers]
          response = action[:response]
        else
          status, headers, response = @app.call(env)
          response = response.body if response.respond_to?(:body)

          store.transaction do
            store[idempotency_key] = {
              status: status,
              headers: headers.to_h,
              response: response
            }
          end
        end

        [status, headers, response]
      else
        @app.call(env)
      end
    end
  end
end
