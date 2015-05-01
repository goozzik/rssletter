class NewslettersController < ApplicationController

  def index
    set_newsletters
  end

  def show
    set_newsletter
    render body: NewsletterToRSS.new(@newsletter).to_rss, layout: false
  end

  private

  def set_newsletter
    @newsletter ||= Newsletter.find(params[:id])
  end

  def set_newsletters
    @newsletters ||= Newsletter.all
  end

end

