json.cache! ['v2/posts_list/page-#{params[:page]}"', @posts], expires_in: 1.minute do
  json.array! @posts, :id, :title, :content, :created_at, :updated_at, :categories
end