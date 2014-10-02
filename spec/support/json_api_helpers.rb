module JsonApiHelpers

  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  RSpec.configure do |config|
    config.include JsonApiHelpers
  end
end