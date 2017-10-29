module IdempotentRequest
  class Redis
    IDEMPOTENCY_HEADER = 'HTTP_IDEMPOTENCY_KEY'.freeze
    REDIS_NAMESPACE = 'idempotency_keys'.freeze

    attr_reader :redis

    def initialize app
      @app = app
      @redis = ::Redis.current
    end

    def call env
      dup._call env
    end

    def _call env
      idempotency_key = env[IDEMPOTENCY_HEADER]

      if idempotency_key.present?
        action = get(idempotency_key)

        if action.present?
          status = action[:status]
          headers = action[:headers]
          response = action[:response]
        else
          status, headers, response = @app.call(env)
          response = response.body if response.respond_to?(:body)

          payload = payload(status, headers, response)
          set(idempotency_key, payload)
        end

        [status, headers, response]
      else
        @app.call(env)
      end
    end

    private

    def get(key)
      data = redis.hgetall namespaced_key(key)
      return nil if data.blank?

      {
        status: data['status'],
        headers: Oj.load(data['headers']),
        response: Oj.load(data['response'])
      }
    end

    def set(key, payload)
      redis.hmset namespaced_key(key), *payload
    end

    def payload(status, headers, response)
      [
        :status, status,
        :headers, Oj.dump(headers.to_h),
        :response, Oj.dump(response)
      ]
    end

    def namespaced_key(idempotency_key)
      "#{REDIS_NAMESPACE}:#{idempotency_key}"
    end
  end
end
