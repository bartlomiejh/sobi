require 'rails_helper'
require 'client'

describe Client do
  describe '#put_package' do
    # @review bhopek: redis mock would be enough
    let(:redis) { Redis.new(host: RedisConfig.host, port: RedisConfig.port) }
    before(:each) { redis.del RedisConfig.queue }

    context 'when id is given' do
      subject do
        described_class.new(RedisConfig).put_package(id)
        JSON.parse(redis.rpop(RedisConfig.queue))
      end

      let(:id) { 91 }
      it { is_expected.to include('bike_id' => 91) }
      it { is_expected.to satisfy('have 690 length message') { |package| package['message'].length == 690 } }
    end

    context 'when id is not given' do
      subject do
        described_class.new(RedisConfig).put_package
        JSON.parse(redis.rpop(RedisConfig.queue))
      end

      it { is_expected.to include('bike_id' => 1) }
      it { is_expected.to satisfy('have 690 length message') { |package| package['message'].length == 690 } }
    end
  end
end
