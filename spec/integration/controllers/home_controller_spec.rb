require 'rails_helper'

RSpec.describe 'RateLimiter' do
	before do
		Rate.configure do |config|
		  config.timer = 5
		  config.max_requests = 1
		end
	end
	after(:each) do
		$redis.flushall
	end
  describe 'root path' do
    it 'should return 200 when rate limit is not exceeded' do
      get root_path
      expect(response.status).to eq(200)
    end
    it 'should return 429 when rate limit is exceeded' do
    	get root_path
    	expect(response.status).to eq(200)
    	get root_path
    	expect(response.status).to eq(429)
    end
    it 'should return 200 after expiry time when rate limit is exceeded' do
    	get root_path
    	expect(response.status).to eq(200)
    	get root_path
    	expect(response.status).to eq(429)
    	sleep(5)
    	get root_path
    	expect(response.status).to eq(200)
    end
  end
end