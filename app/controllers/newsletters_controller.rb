class NewslettersController < ApplicationController
  before_filter :set_newsletter, only: [:new, :create, :destroy]
  http_basic_authenticate_with(
    name: Settings.credentials.username,
    password: Settings.credentials.password,
    only: [:index, :create, :destroy]
  )

  def index
    set_newsletters
  end

  def show
    if newsletter = Newsletter.find_by(hash_id: params[:id])
      render body: NewsletterToRSS.new(newsletter).to_rss, layout: false
    else
      render body: '', status: 404, layout: false
    end
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
