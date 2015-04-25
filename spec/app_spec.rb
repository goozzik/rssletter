require 'spec_helper'
require './app'

describe Rssletter do

  def app
    Rssletter
  end

  describe 'GET /newsletter/:id' do
    let!(:newsletter) do
      FactoryGirl.create(:newsletter)
    end

    context 'when there is newsletter with given id' do
      before do
        allow_any_instance_of(Newsletter).to receive(:to_rss).and_return('test')
      end

      it 'returns 200 response code' do
        get "/newsletter/#{newsletter.id}"

        expect(last_response.status).to eq(200)
      end

      it 'returns converted to RSS newsletter in body' do
        get "/newsletter/#{newsletter.id}"

        expect(last_response.body).to eq(newsletter.to_rss)
      end
    end

    context 'when there is no newsletter with given id' do
      it 'returns 404 code' do
        get "/newsletter/#{newsletter.id + 1}"

        expect(last_response.status).to eq(404)
        expect(last_response.body).to eq('Newsletter not found')
      end
    end
  end

end

