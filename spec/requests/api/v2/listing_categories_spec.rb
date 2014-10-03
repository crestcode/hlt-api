require 'rails_helper'

describe 'Categories API' do
  context 'listing categories' do
    before do
      Category.create!(name: 'Ruby on Rails')
      Category.create!(name: 'Sinatra')
      Category.create!(name: 'Padrino')
    end
    it 'lists all categories' do
      get '/api/v2/categories'

      expect(response.status).to eq(200)
      expect(response.body).to eql(Category.all.to_json)
    end
  end
end