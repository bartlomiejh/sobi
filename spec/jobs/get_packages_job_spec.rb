require 'rails_helper'

describe GetPackagesJob, type: :job do
  describe '.perform' do
    let(:redis) { Redis.new(host: RedisConfig.host, port: RedisConfig.port) }
    before :each do
      redis.del RedisConfig.queue
      packages.each { |p| redis.lpush RedisConfig.queue, p.to_json }
    end
    subject { -> { described_class.perform_now } }

    context 'when there is valid package' do
      let(:packages) { [{ bike_id: 91, message: 'abc' }] }

      it { is_expected.to change { Package.count }.by(1) }
      it { is_expected.to change { Package.all.collect(&:bike_id) }.to([91]) }
      it { is_expected.to change { Package.all.collect(&:message) }.to(['abc']) }
    end

    context 'when there are valid packages' do
      let(:packages) do
        [
          { bike_id: 91, message: 'abc' },
          { bike_id: 92, message: 'efg' },
          { bike_id: 93, message: 'hij' }
        ]
      end

      it { is_expected.to change { Package.count }.by(3) }
      it { is_expected.to change { Package.all.collect(&:bike_id) }.by([91, 92, 93]) }
      it { is_expected.to change { Package.all.collect(&:message) }.by(%w(abc efg hij)) }
    end

    context 'when there are invalid packages' do
      let(:packages) do
        [
          { bike_id: 91, message: 'abc' },
          { invalid: true },
          { bike_id: nil },
          { bike_id: 92, message: 'efg' }
        ]
      end

      it { is_expected.to change { Package.count }.by(2) }
    end
  end
end
