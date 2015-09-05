require 'rails_helper'

describe Package, type: :model do
  describe '#valid?' do
    subject { package.valid? }
    context 'when message is not set' do
      let(:package) { build :package, message: nil }
      it { is_expected.to be_falsey }
    end

    context 'when bike_id is not set' do
      let(:package) { build :package, bike_id: nil }
      it { is_expected.to be_falsey }
    end

    context 'when message and bike_id are set' do
      let(:package) { build :package, message: 'message', bike_id: 1 }
      it { is_expected.to be_truthy }
    end
  end
end
