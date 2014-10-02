require 'rails_helper'

describe 'Categories API' do
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
    expect(JSON.parse(response.body)['errors']).to eql('name'=>['can\'t be blank'])
  end
end