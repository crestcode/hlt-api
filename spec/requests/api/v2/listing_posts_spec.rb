require 'rails_helper'

describe 'Posts API' do
  before do
    category = Category.create!(name: 'Ruby on Rails')
    Post.create!(title: 'Rails 4.2 released', content: 'Get it while it\'s hot!', category_ids: [category.id])
    Post.create!(title: 'Bend your iPhone 6 Plus', content: 'Bend em and send em - upload your videos here!')
    Post.create!(title: 'Infinite Hiatus', content: 'Well, it\'s been fun but I need to take a break. Later!')
  end

  context 'listing posts' do
    it 'lists all posts' do
      get '/api/v2/posts'

      expect(response.status).to eq(200)
      expect(response.body).to eql(Post.all.to_json(include: :categories))
    end
  end

  context 'pagination' do
    before do
      @default_per_page = Kaminari.config.default_per_page
      Kaminari.config.default_per_page = 1
    end

    after do
      Kaminari.config.default_per_page = @default_per_page
    end

    it 'gets the first page of posts' do
      get '/api/v2/posts', page: 1

      expect(response.body).to eql(Post.page(1).to_json(include: :categories))
    end

    it 'gets the second page of posts' do
      get '/api/v2/posts', page: 2

      expect(response.body).to eql(Post.page(2).to_json(include: :categories))
    end
  end
end