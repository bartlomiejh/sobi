class GetPackagesJob < ActiveJob::Base
  queue_as :default

  def perform
    redis = Redis.new(host: 'localhost', port: 6379)

    collect_until_nil { redis.rpop 'queue' }.each do |package_params|
      p = Package.create JSON.parse(package_params).slice('bike_id', 'message')
      # @todo bhopek: add fancy logging - rollbar, snugbug
      p.valid? ? p.save! : Rails.logger.error("Params: #{package_params}, errors: #{p.errors.full_messages}")
    end
  end

  private

  def collect_until_nil
    r = nil
    [].tap { |a| a << r until (r = yield).nil? }
  end
end
