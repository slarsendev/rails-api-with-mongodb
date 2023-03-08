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
    @filtered_params = calculate_params(params)
    
    if !is_value_zero?
      @product = Product.where(:length.gt => @filtered_params[:length],
                              :height.gt => @filtered_params[:height],
                              :width.gte => @filtered_params[:width],
                              :weight.gte => @filtered_params[:weight]).order_by(length: :asc).first
      if @product
        render json: { product_name: "#{@product.type} - #{@product.name}" }, status: :ok
      else
        render json: { message: 'Product not found' }, status: :not_found
      end
    else
      render json: { message: 'Please provide the right input' }, status: :not_found
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :length, :width, :height, :weight)
    end

    def calculate_params(params)
      params = params.permit(:name, :length, :width, :height, :weight).to_h
      Hash[params.map { |k,v| [k.to_sym, v.to_i ]}]
    end

    def find_product
      dimensions = params['dimensions'].split('x').map(&:to_i)
      @product = Product.find_by(length: dimensions.first, width: dimensions.second, height: dimensions.third, weight: params['weight'].to_i)
    end

    def product
      @product = Product.find_by(params[:id])
      render json: { message: 'Product not found.' }, status: :not_found and return if @product.blank?
    end

    def is_value_zero?
      @filtered_params[:length] == 0 || @filtered_params[:height] == 0 || @filtered_params[:width] == 0 || @filtered_params[:weight] == 0
    end
end
