require File.expand_path("../config/application", __FILE__)

class Rssletter

  set :haml, :format => :html5
  set :views, settings.root + '/../views'

  get '/newsletter/:id' do
    begin
      newsletter.to_rss
    rescue ActiveRecord::RecordNotFound
      status 404
      body 'Newsletter not found'
    end
  end

  get '/newsletters' do
    haml :index, locals: { newsletters: newsletters }, views: "#{settings.views}/newsletters/"
  end

  private

  def newsletter
    @newsletter ||= Newsletter.find(params[:id])
  end

  def newsletters
    @newsletters ||= Newsletter.all
  end

end

