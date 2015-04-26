require 'rails_helper'

describe NewslettersController do
  render_views
  let!(:newsletter) { FactoryGirl.create(:newsletter) }

  # GET /newsletters
  describe '#index' do
    let!(:newsletter_2) { FactoryGirl.create(:newsletter) }
    before { get :index }

    it 'returns 200 response code' do
      expect(response.status).to eq(200)
    end

    it 'shows all newsletters' do
      expect(response.body).to include(newsletter.title)
      expect(response.body).to include(newsletter_2.title)
    end

    it 'shows link to new newsletter form' do
      expect(response.body).to include('Add new newsletter')
    end
  end

  # GET /newsletters/:id
  describe '#show' do
    context 'when there is newsletter with given id' do
      before do
        allow_any_instance_of(Newsletter).to receive(:to_rss).and_return('test')
        get :show, id: newsletter.id
      end

      it 'returns 200 response code' do
        expect(response.status).to eq(200)
      end

      it 'returns converted to RSS newsletter in body' do
        expect(response.body).to eq("#{newsletter.to_rss}\n")
      end
    end
  end
end
