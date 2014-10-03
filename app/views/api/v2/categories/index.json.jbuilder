json.cache! ['v2/categories_list/page-#{params[:page]}"', @categories], expires_in: 1.minute do
  json.array! @categories, :id, :name, :created_at, :updated_at
end