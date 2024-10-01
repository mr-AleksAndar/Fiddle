# config/initializers/redis.rb

# Establish a connection to Redis using the REDIS_URL environment variable.
# If REDIS_URL is not set, it defaults to localhost for development and test environments.

Redis.current = Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" })

# Optionally, you can configure other Redis clients or namespaces here.

# Example: Separate Redis instances for caching and Action Cable (if needed)
# CACHE_REDIS = Redis.new(url: ENV.fetch("CACHE_REDIS_URL") { "redis://localhost:6379/2" })
# CABLE_REDIS = Redis.new(url: ENV.fetch("CABLE_REDIS_URL") { "redis://localhost:6379/3" })