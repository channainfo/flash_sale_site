class Admin::DealsController < Admin::BaseController
  
  before_action :set_deal, only: [:edit, :update, :show, :destroy]

  def index
    @live_deals = Deal.live.includes(:images).order(end_at: :desc)
    @expired_deals = Deal.expired.includes(:images).order(end_at: :desc)
    @future_deals = Deal.future.includes(:images).order(:start_at)
    @unpublished_deals = Deal.unpublished.includes(:images)
  end

  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(new_deal_params)
    if @deal.save
      redirect_to admin_deals_url, notice: t(:deal_created, scope: [:flash, :notice])
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @deal.update(update_deal_params)
      redirect_to admin_deals_url, notice: t(:deal_updated, scope: [:flash, :notice])
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    if @deal.destroy
      redirect_to admin_deals_path, notice: t(:deal_successfully_destroyed, scope: [:flash, :notice])
    else
      redirect_to admin_deals_path, alert: t(:deal_cannot_be_destroyed, scope: [:flash, :alert]) + '<br>' + @deal.pretty_errors
    end
  end

  private

    def new_deal_params
      params.require(:deal).permit(:title, :description, :price, :discount_price, :quantity, :publishing_date, images_attributes: [:avatar, :_destroy])
    end

    def update_deal_params
      params.require(:deal).permit(:title, :description, :price, :discount_price, :quantity, :publishing_date, images_attributes: [:id, :avatar, :_destroy])
    end

    def set_deal
      @deal = Deal.find_by(id: params[:id])
      render_404 unless @deal.present?
    end
end
