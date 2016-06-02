class ProductsController < ApplicationController
  include CurrentCart

  before_filter :authenticate_user!, except: [:show]

  before_action :set_cart, only: [:new, :create, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.joins("LEFT JOIN categories on products.category_id = categories.id").order("LOWER(name)","LOWER(title)", "price").paginate(page: params[:page], per_page: 4)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end
  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        flash[:notice] = 'Product was not created.'
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
        if @product.valid? && @product.update(product_params)
          format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          format.json { render status: :ok, location: @product }
        else
          flash[:notice] = 'Product was not valid'
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    message = 'Product was not destroyed.'
    if @product.valid?
      @product.destroy
      if @product.destroyed?
        message = 'Product was successfully destroyed.'
      end
    end
    
    respond_to do |format|
      format.html { redirect_to products_url, notice: message }
      format.json { head :no_content }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
      if stale?(@latest_order)
        respond_to do |format|
          format.atom
        end
      end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      if Product.exists?(params[:id])
        @product = Product.find(params[:id])
      else
        respond_to do |format|
          format.html { redirect_to products_url, notice: 'No such product exists' }
          format.json { render :index, status: :ok, location: @product }
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :category_id, :image_url, :price)
    end

end
