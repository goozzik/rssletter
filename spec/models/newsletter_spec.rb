require 'spec_helper'

describe Newsletter do
  let(:newsletter) { FactoryGirl.build(:newsletter) }

  describe 'before_create callbacks' do
    describe '#set_hash_id' do
      let(:generated_hash) { '123123sadqweqweqwe' }
      let(:time_now) { Time.local(1990) }

      before do
        Timecop.freeze(time_now)
        allow(Digest::SHA1).to receive(:hexdigest).with("#{time_now.to_i}1") {
          generated_hash
        }
      end

      after { Timecop.return }

      it 'sets hash' do
        expect { newsletter.save }.to change { newsletter.hash_id }.to(
          generated_hash
        )
      end
    end
  end
end
