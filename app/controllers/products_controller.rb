class ProductsController < ApplicationController
  before_action :find_product, only: %i(show)
  
  def index
    render json: Product.all
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: { product: @product, message: 'Product is created successfully.' }, status: :created
    else
      render json: { message: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if product.update(product_params)
      render json: { product: @product, message: 'Product is updated successfully.' }, status: 200
    else
      render json: { message: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @product
      render json: { product: @product }, status: 200
    else
      render json: { message: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if product.destroy
      render json: { message: 'Product is deleted successfully.' }, status: 200
    else
      render json: { message: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :length, :width, :height, :weight)
    end

    def find_product
      dimensions = params['dimensions'].split('x').map(&:to_i)
      @product = Product.find_by(length: dimensions.first, width: dimensions.second, height: dimensions.third, weight: params['weight'].to_i)
    end

    def product
      @product = Product.find_by(params[:id])
      render json: { message: 'Product not found.' }, status: :unprocessable_entity and return if @product.blank?
    end
end
