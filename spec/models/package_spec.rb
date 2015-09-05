require 'rails_helper'

describe Package, type: :model do
  describe '#valid?' do
    subject { package.valid? }
    context 'when message is not set' do
      let(:package) { build :package, message: nil }
      it { is_expected.to be_falsey }
    end

    context 'when bikeId is not set' do
      let(:package) { build :package, bikeId: nil }
      it { is_expected.to be_falsey }
    end

    context 'when message and bikeId are set' do
      let(:package) { build :package, message: 'message', bikeId: 1 }
      it { is_expected.to be_truthy }
    end
  end
end
