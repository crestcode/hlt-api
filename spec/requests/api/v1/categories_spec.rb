require 'rails_helper'

describe 'Categories API' do
  context 'creating categories' do
    it 'creates a new category' do
      post '/api/v1/categories', { category: { name: 'Ruby on Rails' } }.to_json, { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

      expect(response.status).to eq(201)
      expect(response.content_type).to eq(Mime::JSON)

      category = JSON.parse(response.body, symbolize_names: true)
      expect(response.location).to eq(api_v1_category_url(category[:id]))
      expect(category[:name]).to eq('Ruby on Rails')
    end

    it 'does not create a category without a name' do
      post '/api/v1/categories', { category: { name: nil } }.to_json, { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

      expect(response.status).to eq(422)
      category = JSON.parse(response.body, symbolize_names: true)
      expect(category[:errors]).to eql(:name => ['can\'t be blank'])
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
end