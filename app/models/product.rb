class Product
  include Mongoid::Document
  include ActiveModel::Validations
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated
  
  field :name, type: String
  field :type, type: String
  field :length, type: Integer
  field :height, type: Integer
  field :width, type: Integer
  field :weight, type: Integer

  validates :name, :type, :length, :height, :width, :weight, presence: true
  validates :length, :height, :width, :weight, numericality: { only_integer: true }

  validate :dimensions

  def dimensions
    errors.add(:product, "'s length and heigth should be greater than width") if length <= width || height <= width  
  end
end
