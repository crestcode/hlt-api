require 'rails_helper'

describe 'Categories API' do
  context 'updating categories' do
    before do
      @api_key = ApiKey.create!
      @category = Category.create!(name: 'Ruby on Rails')
    end

    it 'updates an existing category' do
      put "/api/v2/categories/#{@category.id}", { category: { name: 'Rails 4' } }.to_json, {
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
      put "/api/v2/categories/#{@category.id}", { category: { name: nil } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(422)
      category = json(response.body)
      expect(category[:errors]).to eql(:name => ['can\'t be blank'])
    end

    it 'returns 404 if invalid category id' do
      @category.destroy

      put "/api/v2/categories/#{@category.id}", { category: { name: 'Rails 4' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(404)
      category = json(response.body)
      expect(category[:error]).to eql('The category you were looking for could not be found')
    end

    it 'does not update an existing category without a valid api key token' do
      @api_key.destroy

      put "/api/v2/categories/#{@category.id}", { category: { name: 'Rails 4' } }.to_json, {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=\"#{@api_key.token}\""
      }

      expect(response.status).to eq(401)
    end
  end
end