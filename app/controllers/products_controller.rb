class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    @products = Product.all.order(:title)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /products/1 or /products/1.json
  def show
    @logged_in_user_product_rating = logged_in_user_product_rating(params[:id])
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.pluck(:name, :id)
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)
    @categories = Category.pluck(:name, :id)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: t('created', resource_name: 'Product') }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: t('updated', resource_name: 'Product') }
        format.json { render :show, status: :ok, location: @product }

        @products = Product.all.order(:title)
        ActionCable.server.broadcast 'products', html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: t('destroyed', resource_name: 'Product') }
      format.json { head :no_content }
    end
  end

  def rate
    @rating = Rating.find_or_initialize_by(user_id: @logged_in_user.id, product_id: params[:product_id])
    @rating.rating = params[:rating]
    
    respond_to do |format|
      if @rating.save!
        format.json { render json: :created }
      else
        format.json { render json: :unprocessable_entity }
      end
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
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      # params[:category_id] = Category.where(name: params[:category_name]).pluck(:id)
      params.require(:product).permit(:title, :description, :image_url, :price, :permalink, :discount_price, :enabled, :category_id)
    end

    def logged_in_user_product_rating(product_id)
      Rating.where(user_id: @logged_in_user.id, product_id: product_id).first.rating
    end
end
