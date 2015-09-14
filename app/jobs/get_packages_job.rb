class GetPackagesJob < ActiveJob::Base
  queue_as :default

  before_perform do
    # @review bhopek: what with closing connection
    @redis = Redis.new(host: RedisConfig.host, port: RedisConfig.port)
  end

  def perform
    collect_until_nil { @redis.rpop RedisConfig.queue }.each do |package_params|
      p = Package.create JSON.parse(package_params).slice('bike_id', 'message')
      # @review bhopek: add fancy logging - rollbar, snugbug
      p.valid? ? p.save! : Rails.logger.error("Params: #{package_params}, errors: #{p.errors.full_messages}")
    end
  end

  private

  def collect_until_nil
    r = nil
    [].tap { |a| a << r until (r = yield).nil? }
  end
end
