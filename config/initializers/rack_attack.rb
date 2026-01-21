# frozen_string_literal: true

# Basic API rate limiting.
#
# Protects the API from accidental or abusive polling.
# Default: 10 requests per minute per IP for /api/*

class Rack::Attack
  # Use Rails cache for throttling. In production you probably want a shared cache
  # (Redis/Memcached) if you ever scale to multiple machines.
  self.cache.store = Rails.cache

  throttle("api/ip", limit: 10, period: 1.minute) do |request|
    next unless request.path.start_with?("/api/")

    request.ip
  end

  self.throttled_responder = lambda do |_request|
    [
      429,
      { "Content-Type" => "application/json" },
      [JSON.generate({ error: "rate_limited", message: "Too many requests" })]
    ]
  end
end
