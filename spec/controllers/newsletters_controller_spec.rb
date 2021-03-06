require 'rails_helper'

describe NewslettersController do
  render_views
  let!(:newsletter) { FactoryGirl.create(:newsletter) }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
      Settings.credentials.username,
      Settings.credentials.password
    )
  end

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
    context 'when there is newsletter with given hash_id' do
      let(:newsletter_to_rss) do
        instance_double('NewsletterToRSS', to_rss: 'test')
      end
      before do
        allow(NewsletterToRSS).to receive(:new).with(
          newsletter
        ).and_return(newsletter_to_rss)
        get :show, id: newsletter.hash_id
      end

      it 'returns 200 response code' do
        expect(response.status).to eq(200)
      end

      it 'returns converted to RSS newsletter in body' do
        expect(response.body).to eq("#{newsletter_to_rss.to_rss}")
      end
    end

    context 'when there is no newsletter with given hash_id' do
      let(:hash_id) { '123123123123' }

      it 'returns 404 response code' do
        get :show, id: hash_id

        expect(response.status).to eq(404)
      end
    end
  end

  # GET /newsletters/new
  describe '#new' do
    it 'returns success response' do
      get :new

      expect(response.status).to eq(200)
    end
  end

  # POST /newsletters
  describe '#create' do
    let(:newsletter_params) do
      {
        title: 'Newsletter',
        email: 'newsletter@gmail.com',
        domain: 'newsletter.com'
      }
    end

    context 'when newsletter params are valid' do
      it 'redirects to index page' do
        expect(
          post :create, newsletter_params
        ).to redirect_to('/newsletters')

        expect(response.status).to eq(302)
      end

      it 'creates new newsletter' do
        expect { post :create, newsletter_params }.to change {
          Newsletter.count
        }.by(1)
      end
    end

    context 'when newsletter params are invalid' do
      before do
        allow_any_instance_of(Newsletter).to receive(:save) { false }
      end

      it 'renders new partial' do
        expect(
          post :create, newsletter_params
        ).to render_template('new')
        expect(response.status).to eq(422)
      end

      it 'does not create new newsletter' do
        expect { post :create, newsletter_params }.to_not change {
          Newsletter.count
        }
      end
    end
  end

  # POST /newsletters
  describe '#destroy' do
    let!(:newsletter) { FactoryGirl.create(:newsletter) }

    it 'destroys newsletter' do
      expect {
        delete :destroy, id: newsletter.id
      }.to change { Newsletter.count }.by(-1)
    end

    it 'redirects to index page' do
      expect(
        delete :destroy, id: newsletter.id
      ).to redirect_to('/newsletters')

      expect(response.status).to eq(302)
    end
  end
end
