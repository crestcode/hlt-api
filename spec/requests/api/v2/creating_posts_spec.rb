require 'rails_helper'

describe 'Posts API' do
  context 'creating posts' do
    before do
      @api_key = ApiKey.create!
    end
    it 'creates a new post' do
      category = Category.create!(name: 'Ruby on Rails')
      post '/api/v2/posts', { post: { title: 'Rails 4.2 released', content: 'Get it while it\'s hot!', category_ids: [category.id] } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)

      post = json(response.body)
      expect(response.location).to eq(api_v2_post_url(post[:id]))
      expect(post[:title]).to eq('Rails 4.2 released')
      expect(post[:content]).to eq('Get it while it\'s hot!')
      expect(post[:categories].any? { |c| c[:id] == category.id }).to be(true)

    end

    it 'does not create a post without a title or content' do
      post '/api/v2/posts', { post: { title: nil, content: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      post = json(response.body)
      expect(post[:errors]).to include(:title => ['can\'t be blank'])
      expect(post[:errors]).to include(:content => ['can\'t be blank'])
    end

    it 'does not create a new post without a valid api key token' do
      @api_key.destroy

      post '/api/v2/posts', { post: { title: 'Rails 4.2 released', content: 'Get it while it\'s hot!' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end
end