class Api::V1::CategoriesController < ApplicationController
  before_action :get_category, only: :update
  before_action :token_authentication, only: [:create, :update]
  respond_to :json

  def index
    respond_with(Category.all)
  end

  def create
    category = Category.new(category_params)
    if category.save
      respond_with(category, location: api_v1_category_url(category))
    else
      respond_with(category)
    end
  end

  def update
    @category.update_attributes(category_params)
    respond_with(@category)
  end

  private

  def category_params
    params.fetch(:category, {}).permit(:name)
  end

  def get_category
    @category = Category.find_by_id(params[:id])
    render json: {error: 'The category you were looking for could not be found'}, status: 404 unless @category
  end

  def token_authentication
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(token: token)
    end
  end
end