# Rate Limiter

## Prerequisites
```
1. Ruby (Recommended Version: 2.3.1p112)
2. Rails (Recommended Version: 5.0.6)
3. SQLite (Recommended Version: 3.8.5)
4. Redis server (Recommended Version: 3.2.1)
```

## User Defined Gems
```
1. redis for storage
2. rspec-rails for test suite
```

## Implementation
### Intializers
```
1. throttler_paramters.rb
	a. sets the timer
	b. sets the max_requests
```
### Middlewares
```
1. Throttler
	a. Calls application if the rate limit of a client for a url is not reached
	b. Responds with 429 in case rate limit has been reached
```
### Controllers
```
1. ApplicationController
	a. Defines an action throttle_api which can be called before any action in controllers inheriting application controller
	b. When called before any action then rate limits are applied to that action
2. HomeController
	a. Defines an action index corresponding to root path
	b. It returns plain text 'ok'
	c. throttle_api is called before it
```
### Services
```
1. Rate::Configuration
	a. Implementation of configuration pattern to set the configuration of rate module from initializers
2. Rate::Limiter
	a. Defines a method set which stores count of requests made by a client for a url
	b. Defines a method exceeded? which checks if requests made by the client for the url exceed the rate limit
	c. Defines a method expiry_time which returns to the seconds left after which rate limit will be refreshed
```
### Tests
```
1. Integration Tests
	a. home_controller_spec.rb (tests the whole objective of the application)
2. Unit Tests (100 pc coverage)
	a application_controller_spec.rb
	b. home_controller_spec.rb
	c. throttler_spec.rb
	d. rate_spec.rb
	e. rate/configuration_spec.rb
	f. rate/limiter_spec.rb
```
## Proof of work
#### Execution
```
bundle exec rspec spec/integration/controllers/home_controller_spec.rb
```
### spec/integration/controllers/home_controller_spec.rb
```
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
```