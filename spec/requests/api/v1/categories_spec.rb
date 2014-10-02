require 'rails_helper'

describe 'Categories API' do

  context 'creating categories' do
    before do
      @api_key = ApiKey.create!
    end
    it 'creates a new category' do
      post '/api/v1/categories', { category: { name: 'Ruby on Rails' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)

      category = JSON.parse(response.body, symbolize_names: true)
      expect(response.location).to eq(api_v1_category_url(category[:id]))
      expect(category[:name]).to eq('Ruby on Rails')
    end

    it 'does not create a category without a name' do
      post '/api/v1/categories', { category: { name: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      category = JSON.parse(response.body, symbolize_names: true)
      expect(category[:errors]).to eql(:name => ['can\'t be blank'])
    end

    it 'does not create a new category without a valid api key token' do
      @api_key.destroy

      post '/api/v1/categories', { category: { name: 'Ruby on Rails' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end

  context 'listing categories' do
    before do
        Category.create!(name: 'Ruby on Rails')
        Category.create!(name: 'Sinatra')
        Category.create!(name: 'Padrino')
    end
    it 'lists all categories' do
      get '/api/v1/categories'

      expect(response.status).to eq(200)
      expect(response.body).to eql(Category.all.to_json)
    end
  end

  context 'updating categories' do
    before do
      @api_key = ApiKey.create!
      @category = Category.create!(name: 'Ruby on Rails')
    end

    it 'updates an existing category' do
      put "/api/v1/categories/#{@category.id}", { category: { name: 'Rails 4' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(204)
      expect(response.body).to eq('')

      @category.reload
      expect(@category.name).to eq('Rails 4')
    end

    it 'does not update an existing category without a name' do
      put "/api/v1/categories/#{@category.id}", { category: { name: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      category = JSON.parse(response.body, symbolize_names: true)
      expect(category[:errors]).to eql(:name => ['can\'t be blank'])
    end

    it 'returns 404 if invalid category id' do
      @category.destroy

      put "/api/v1/categories/#{@category.id}", { category: { name: 'Rails 4' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(404)
      category = JSON.parse(response.body, symbolize_names: true)
      expect(category[:error]).to eql('The category you were looking for could not be found')
    end

    it 'does not update an existing category without a valid api key token' do
      @api_key.destroy

      put "/api/v1/categories/#{@category.id}", { category: { name: 'Rails 4' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end
end