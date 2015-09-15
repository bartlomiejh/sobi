require 'rails_helper'
require 'client'

describe 'Client server communication', type: :request do
  let(:redis) { Redis.new(host: RedisConfig.host, port: RedisConfig.port) }
  before :each do
    redis.del RedisConfig.queue
  end
  context 'when packages are valid' do
    it 'saves all sent packages and display them to the user' do
      Client.new(RedisConfig).put_package(91)
      Client.new(RedisConfig).put_package(92)
      Client.new(RedisConfig).put_package(93)
      GetPackagesJob.perform_now

      expect(Package.all.collect(&:bike_id)).to eq [91, 92, 93]

      get packages_path
      expect(assigns(:packages).collect(&:bike_id)).to eq [93, 92, 91]
    end
  end

  context 'when there are invalid packages' do
    it 'saves only valid ones and displays them to the user' do
      Client.new(RedisConfig).put_package(91)
      Client.new(RedisConfig).put_package(nil)
      Client.new(RedisConfig).put_package(93)
      Client.new(RedisConfig).put_package(nil)
      Client.new(RedisConfig).put_package(95)
      GetPackagesJob.perform_now

      expect(Package.all.collect(&:bike_id)).to eq [91, 93, 95]

      get packages_path
      expect(assigns(:packages).collect(&:bike_id)).to eq [95, 93, 91]
    end
  end
end
