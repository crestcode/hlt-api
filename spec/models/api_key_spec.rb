require 'rails_helper'

describe ApiKey, :type => :model do
  it 'generates a token when created' do
    api_key = ApiKey.create!

    expect(api_key.token.length).to eq(32)
  end
end
