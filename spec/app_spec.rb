require 'spec_helper'
require './app'

describe Rssletter do

  def app
    Rssletter
  end

  let!(:newsletter) do
    FactoryGirl.create(:newsletter)
  end

  describe 'GET /newsletter/:id' do
    context 'when there is newsletter with given id' do
      before do
        allow_any_instance_of(Newsletter).to receive(:to_rss).and_return('test')
        get "/newsletter/#{newsletter.id}"
      end

      it 'returns 200 response code' do
        expect(last_response.status).to eq(200)
      end

      it 'returns converted to RSS newsletter in body' do
        expect(last_response.body).to eq(newsletter.to_rss)
      end
    end

    context 'when there is no newsletter with given id' do
      before { get "/newsletter/#{newsletter.id + 1}" }

      it 'returns 404 response code' do
        expect(last_response.status).to eq(404)
      end

      it 'returns `Newsletter not found` in body' do
        expect(last_response.body).to eq('Newsletter not found')
      end
    end
  end

  describe 'GET /newsletters' do
    let!(:newsletter_2) { FactoryGirl.create(:newsletter) }
    before { get '/newsletters' }

    it 'returns 200 response code' do
      expect(last_response.status).to eq(200)
    end

    it 'returns all newsletters in body' do
      expect(last_response.body).to include(newsletter.title)
      expect(last_response.body).to include(newsletter_2.title)
    end
  end

end

