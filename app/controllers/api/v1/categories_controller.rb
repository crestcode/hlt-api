class Api::V1::CategoriesController < ApplicationController
  respond_to :json

  def index
    respond_with(Category.all)
  end

  def create
    category = Category.new(category_params)
    if category.save
      respond_with(category, :location => api_v1_category_url(category))
    else
      respond_with(category)
    end
  end

  private

  def category_params
    params.fetch(:category, {}).permit(:name)
  end
end