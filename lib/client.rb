require 'redis'
require 'json'

class Client
  def initialize(redis_config)
    @redis = Redis.new(host: redis_config.host, port: redis_config.port)
    @queue = redis_config.queue
  end

  def put_package(id = 1)
    @redis.lpush @queue, { bike_id: id, message: generate_random }.to_json
  end

  private

  def generate_random
    SecureRandom.hex(690 / 2)
  end
end
