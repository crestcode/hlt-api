require 'rails_helper'

describe 'Posts API' do
  context 'updating posts' do
    before do
      @api_key = ApiKey.create!
      @post = Post.create!(title: 'Rails 4.2 released', content: 'Get it while it\'s hot!')
    end

    it 'updates an existing post' do
      put "/api/v2/posts/#{@post.id}", { post: { title: 'Rails 4.2.0.beta2 released' } }.to_json, {
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
      put "/api/v2/posts/#{@post.id}", { post: { title: nil, content: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      post = json(response.body)
      expect(post[:errors]).to include(:title => ['can\'t be blank'])
      expect(post[:errors]).to include(:content => ['can\'t be blank'])
    end

    it 'returns 404 if invalid post id' do
      @post.destroy

      put "/api/v2/posts/#{@post.id}", { post: { title: 'Rails 4.2.0.beta2 released' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(404)
      post = json(response.body)
      expect(post[:error]).to eql('The post you were looking for could not be found')
    end

    it 'does not update an existing post without a valid api key token' do
      @api_key.destroy

      put "/api/v2/posts/#{@post.id}", { post: { title: 'Rails 4.2.0.beta2 released' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end
end