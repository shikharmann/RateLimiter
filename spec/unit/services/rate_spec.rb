require 'rails_helper'

RSpec.describe Rate do
  describe 'configure and reset configuration' do
    it 'should set configuration to specified values when configured and then again to default values when reset' do
      # Expecting Rate::Configuration.new
      configuration = double(Rate::Configuration, timer: 10, max_requests: 2)
      expect(Rate::Configuration).to receive(:new).and_return(configuration)

      # Configuring configuration
      Rate.configure do |config|
        config.timer = 5
        config.max_requests = 1
      end

      expect(Rate.configuration.timer).to eq(5)
      expect(Rate.configuration.max_requests).to eq(1)

      # Resetting configuration
      Rate.reset

      expect(Rate.configuration.timer).to eq(10)
      expect(Rate.configuration.max_requests).to eq(2)
    end
  end
end