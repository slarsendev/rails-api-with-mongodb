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
      render json: { product: @product, message: 'Product is updated successfully.' }, status: :ok
    else
      render json: { message: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @product
      render json: { product: @product }, status: :ok
    else
      render json: { message: 'Product not found' }, status: :not_found
    end
  end

  def destroy
    if product.destroy
      render json: { message: 'Product is deleted successfully.' }, status: :ok
    else
      render json: { message: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def calculate
    @product = Product.find_by(calculate_params(params))
    if @product
      render json: { product_name: "#{@product.type} - #{@product.name.split.first}" }, status: :ok
    else
      render json: { message: 'Product not found' }, status: :not_found
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :length, :width, :height, :weight)
    end

    def calculate_params(params)
      params = params.permit(:name, :length, :width, :height, :weight).to_h
      Hash[params.map { |k,v| [k, v.to_i ]}]
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
