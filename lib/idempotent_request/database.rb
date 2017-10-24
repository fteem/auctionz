module IdempotentRequest
  class Database
    IDEMPOTENCY_HEADER = 'HTTP_IDEMPOTENCY_KEY'.freeze

    def initialize app
      @app = app
    end

    def call env
      dup._call env
    end

    def _call env
      idempotency_key = env[IDEMPOTENCY_HEADER]

      if idempotency_key.present?
        action = IdempotentAction.find_by(idempotency_key: idempotency_key)

        if action.present?
          status = action.status
          headers = Oj.load(action.headers)
          body = Oj.load(action.body)
        else
          status, headers, response = @app.call(env)
          response = response.body if response.respond_to?(:body)

          IdempotentAction.create(
            idempotency_key: idempotency_key,
            body: Oj.dump(response),
            status: status,
            headers: Oj.dump(headers)
          )
        end

        [status, headers, body]
      else
        @app.call(env)
      end
    end
  end
end
