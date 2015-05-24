require 'rails_helper'

describe Api::MailgunController do
  let(:token) { 'token' }
  let(:timestamp) { '123' }
  let(:signature) { 'signature' }
  let(:authentication_params) do
    { token: token, timestamp: timestamp, signature: signature }
  end
  let(:authentication_service) do
    instance_double('Mailgun::AuthenticationService', verify: true)
  end

  before do
    allow(Mailgun::AuthenticationService).to receive(:new).with(
      token, timestamp, signature
    ) { authentication_service }
  end

  shared_examples 'authentication required action' do
    context 'when authentication signature is valid' do
      it 'does not respond with 401 code' do
        subject

        expect(response.status).to_not eq(401)
      end
    end

    context 'when authentication signature is invalid' do
      before do
        allow(authentication_service).to receive(:verify) { false }
      end

      it 'responds with 401 code' do
        subject

        expect(response.status).to eq(401)
      end
    end
  end

  # POST /api/mailgun/new_mail
  describe '#new_mail' do
    subject { post :new_mail, params}

    let(:params) { authentication_params }
    let(:mail_processor_service) do
      instance_double('Mailgun::MailProcessorService', process: true)
    end

    before do
      allow(Mailgun::MailProcessorService).to receive(:new).with(
        params
      ).and_return(mail_processor_service)
    end

    it_behaves_like 'authentication required action'

    it 'calls Mailgun::MailProcessorService' do
      expect(mail_processor_service).to receive(:process)

      subject
    end
  end
end
