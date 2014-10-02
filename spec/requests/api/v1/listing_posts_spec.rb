require 'rails_helper'

describe 'Posts API' do
  context 'listing posts' do
    before do
      Post.create!(title: 'Rails 4.2 released', content: 'Get it while it\'s hot!')
      Post.create!(title: 'Bend your iPhone 6 Plus', content: 'Bend em and send em - upload your videos here!')
      Post.create!(title: 'Infinite Hiatus', content: 'Well, it\'s been fun but I need to take a break. Later!')
    end
    it 'lists all posts' do
      get '/api/v1/posts'

      expect(response.status).to eq(200)
      expect(response.body).to eql(Post.all.to_json)
    end
  end
end