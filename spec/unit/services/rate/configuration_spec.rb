require 'rails_helper'

RSpec.describe Rate::Configuration do
  describe '.new' do
    it 'should initialize configuration with default values' do
      configuration = Rate::Configuration.new
      expect(configuration.timer).to eq(3600)
      expect(configuration.max_requests).to eq(100)
    end
  end
end