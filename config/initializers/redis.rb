$redis = if Rails.env.production?
    Redis.new(url: ENV.fetch("REDIS_URL"))
  else
    Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })
  end