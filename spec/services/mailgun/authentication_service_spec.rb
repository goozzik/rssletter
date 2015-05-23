require 'rails_helper'

describe Mailgun::AuthenticationService do
  let(:mailgun_api_key) { '1234abcd' }
  let(:token) { '1234token1234' }
  let(:timestamp) { '123123123123' }
  let(:signature) { '123sig123' }

  before do
    allow(Settings).to receive(:mailgun).and_return(
      double('mailgun_settings', api_key: mailgun_api_key)
    )
  end

  subject { described_class.new(token, timestamp, signature) }

  describe '#verify' do
    context 'when signature is valid' do
      let(:signature) do
        '1f5f32afd7cc7fa9148ff5f7b7f2100aef8d40a295eecd7b87fd69a3d6c262dd'
      end

      it 'returns true' do
        expect(subject.verify).to be_truthy
      end
    end

    context 'when signature is invalid' do
      it 'returns false' do
        expect(subject.verify).to be_falsey
      end
    end
  end
end
