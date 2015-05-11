class NewslettersController < ApplicationController
  before_filter :set_newsletter, only: [:new, :show, :create, :destroy]

  def index
    set_newsletters
  end

  def show
    set_newsletter
    render body: NewsletterToRSS.new(@newsletter).to_rss, layout: false
  end

  def new; end

  def create
    if @newsletter.save
      redirect_to action: :index
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @newsletter.destroy
    redirect_to action: :index
  end

  private

  def set_newsletter
    @newsletter ||= if params[:id].present?
      Newsletter.find(params[:id])
    else
      Newsletter.new(params[:newsletter].present? ? newsletter_params : {})
    end
  end

  def set_newsletters
    @newsletters ||= Newsletter.all
  end

  def newsletter_params
    params[:newsletter].permit(:title, :domain, :email)
  end
end
