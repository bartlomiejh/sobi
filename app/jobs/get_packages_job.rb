class GetPackagesJob < ActiveJob::Base
  queue_as :default

  def perform
    redis = Redis.new(host: 'localhost', port: 6379)

    collect_until_nil { redis.rpop 'queue' }.each do |package_params|
      Package.create! JSON.parse(package_params)
    end
  end

  private

  def collect_until_nil
    r = nil
    [].tap { |a| a << r until (r = yield).nil? }
  end
end
