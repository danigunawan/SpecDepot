class StoreController < ApplicationController
  skip_before_action :authorize

  include CurrentCart
  before_action :set_cart

  def index
    if params[:search_query].nil?
      # if params[:set_locale]
 #        redirect_to store_url(locale: params[:set_locale])
 #      else
        @products = Product.joins("LEFT JOIN categories on products.category_id = categories.id").order("LOWER(name)","LOWER(title)", "price").paginate(page: params[:page], per_page: 4)
    #  end
    else
      @search_category = params[:search_category]
      @products = Product.joins("LEFT JOIN categories on products.category_id = categories.id").
                  where((@search_category == "category") ? 
                  'name LIKE ' + "'%#{params[:search_query]}%'" : 'title LIKE ' + "'%#{params[:search_query]}%'")     
      @products = @products.order("LOWER(name)","LOWER(title)", "price").paginate(page: params[:page], per_page: 4)
    end
  end

end
