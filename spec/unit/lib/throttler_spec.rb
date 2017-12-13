require 'rails_helper'

RSpec.describe Throttler do
  let(:app) { proc{ [200, { 'Content-Type' => 'text/html' }, ['ok']] } }
  let(:stack) { Throttler.new(app) }
  let(:env) { Rack::MockRequest.env_for('/test') }

  describe 'Rate Limiter' do
    it 'should respond with 200 if rate limit is not reached' do
      env['REQUEST_PATH'] = '/test'
      env['REMOTE_ADDR'] = '123'
      limiter = double(Rate::Limiter)
      expect(Rate::Limiter).to receive(:new).with('123', '/test').and_return(limiter)
      expect(limiter).to receive(:exceeded?).and_return(false)
      expect(stack.call(env)).to eq([200, { 'Content-Type' => 'text/html' }, ['ok']])
    end
    it 'should respond with 429 if rate is reached' do
      env['REQUEST_PATH'] = '/test'
      env['REMOTE_ADDR'] = '123'
      limiter = double(Rate::Limiter)
      expect(Rate::Limiter).to receive(:new).with('123', '/test').and_return(limiter)
      expect(limiter).to receive(:exceeded?).and_return(true)
      expect(limiter).to receive(:expiry_time).and_return(5)
      expect(stack.call(env)).to eq([429, { 'Content-Type' => 'text/html' }, ['Rate limit exceeded. Try again in 5 seconds']])
    end
  end
end