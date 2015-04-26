class NewslettersController < ApplicationController

  def index
    set_newsletters
  end

  def show
    set_newsletter
    render layout: false
  end

  private

  def set_newsletter
    @newsletter ||= Newsletter.find(params[:id])
  end

  def set_newsletters
    @newsletters ||= Newsletter.all
  end

end

