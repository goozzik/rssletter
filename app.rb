require File.expand_path("../config/application", __FILE__)

class Rssletter

  get '/newsletter/:id' do
    begin
      newsletter.to_rss
    rescue ActiveRecord::RecordNotFound
      status 404
      body 'Newsletter not found'
    end
  end

  private

  def newsletter
    @newsletter ||= Newsletter.find(params[:id])
  end

end

