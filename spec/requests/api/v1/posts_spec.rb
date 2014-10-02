require 'rails_helper'

describe 'Posts API' do
  context 'creating posts' do
    before do
      @api_key = ApiKey.create!
    end
    it 'creates a new post' do
      post '/api/v1/posts', { post: { title: 'Rails 4.2 released', content: 'Get it while it\'s hot!' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)

      post = JSON.parse(response.body, symbolize_names: true)
      expect(response.location).to eq(api_v1_post_url(post[:id]))
      expect(post[:title]).to eq('Rails 4.2 released')
      expect(post[:content]).to eq('Get it while it\'s hot!')
    end

    it 'does not create a post without a title or content' do
      post '/api/v1/posts', { post: { title: nil, content: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      post = JSON.parse(response.body, symbolize_names: true)
      expect(post[:errors]).to include(:title => ['can\'t be blank'])
      expect(post[:errors]).to include(:content => ['can\'t be blank'])
    end

    it 'does not create a new post without a valid api key token' do
      @api_key.destroy

      post '/api/v1/posts', { category: { title: 'Rails 4.2 released', content: 'Get it while it\'s hot!' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end

  context 'listing posts' do
    before do
      Post.create!(title: 'Rails 4.2 released', content: 'Get it while it\'s hot!')
      Post.create!(title: 'Bending the iPhone 6 Plus', content: 'Submit videos of your bent phones here!')
      Post.create!(title: 'Infinite Hiatus', content: 'Well, it\'s been fun but I need to take a break. Later!')
    end
    it 'lists all posts' do
      get '/api/v1/posts'

      expect(response.status).to eq(200)
      expect(response.body).to eql(Post.all.to_json)
    end
  end

  context 'updating posts' do
    before do
      @api_key = ApiKey.create!
      @post = Post.create!(title: 'Rails 4.2 released', content: 'Get it while it\'s hot!')
    end

    it 'updates an existing post' do
      put "/api/v1/posts/#{@post.id}", { post: { title: 'Rails 4.2.0.beta2 released' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(204)
      expect(response.body).to eq('')

      @post.reload
      expect(@post.title).to eq('Rails 4.2.0.beta2 released')
    end

    it 'does not update an existing post without a title or content' do
      put "/api/v1/posts/#{@post.id}", { post: { title: nil, content: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      post = JSON.parse(response.body, symbolize_names: true)
      expect(post[:errors]).to include(:title => ['can\'t be blank'])
      expect(post[:errors]).to include(:content => ['can\'t be blank'])
    end

    it 'returns 404 if invalid post id' do
      @post.destroy

      put "/api/v1/posts/#{@post.id}", { post: { title: 'Rails 4.2.0.beta2 released' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(404)
      post = JSON.parse(response.body, symbolize_names: true)
      expect(post[:error]).to eql('The post you were looking for could not be found')
    end

    it 'does not update an existing post without a valid api key token' do
      @api_key.destroy

      put "/api/v1/posts/#{@post.id}", { post: { title: 'Rails 4.2.0.beta2 released' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end
end