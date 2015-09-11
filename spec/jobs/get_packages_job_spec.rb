require 'rails_helper'

describe GetPackagesJob, type: :job do
  describe '.perform' do
    let(:redis) { Redis.new(host: 'localhost', port: 6379) }
    before :each do
      packages.each { |p| redis.lpush 'queue', p.to_json }
    end
    subject { -> { described_class.perform_now } }

    context 'when there is valid package' do
      let(:packages) { [{ bike_id: 91, message: 'abc' }] }

      it { is_expected.to change { Package.count }.by(1) }
      it { is_expected.to change { Package.all.collect(&:bike_id) }.to([91]) }
      it { is_expected.to change { Package.all.collect(&:message) }.to(['abc']) }
    end
  end
end
