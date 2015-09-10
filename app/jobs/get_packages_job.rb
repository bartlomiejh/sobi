class GetPackagesJob < ActiveJob::Base
  queue_as :default

  def perform
    redis = Redis.new(host: 'localhost', port: 6379)
    Package.create! JSON.parse(redis.rpop 'queue')
  end
end
