class StoreController < ApplicationController
  skip_before_action :authorize

  include CurrentCart
  before_action :set_cart

  def index
    if params[:set_locale]
      redirect_to store_url(locale: params[:set_locale])
    else
      @products = Product.joins("LEFT JOIN categories on products.category_id = categories.id").order("LOWER(name)","LOWER(title)", "price").paginate(page: params[:page], per_page: 4)
    end
  end
end
