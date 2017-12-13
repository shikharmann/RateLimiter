require 'rails_helper'

RSpec.describe Rate::Limiter do
  describe '.new' do
    it 'should initialize configuration with default values' do
      limiter = Rate::Limiter.new('123', '/test')
      expect(limiter.key).to eq('REMOTE_ADDR_123-REQUEST_PATH_/test')
    end
  end
  describe '#set' do
    it 'should increment the key if key exists in redis' do
      limiter = Rate::Limiter.new('123', '/test')
      expect($redis).to receive(:exists).with(limiter.key).and_return(true)
      expect($redis).to receive(:incr).with(limiter.key).and_return(2)
      expect(limiter.set).to eq(2)
    end
    it 'should set the key if key does not exist in redis' do
      limiter = Rate::Limiter.new('123', '/test')
      expect($redis).to receive(:exists).with(limiter.key).and_return(false)
      expect(Rate).to receive_message_chain(:configuration, :timer).and_return(5)
      expect($redis).to receive(:setex).with(limiter.key, 5, 1).and_return('OK')
      expect(limiter.set).to eq('OK')
    end
  end
  describe '#exceeded?' do
    it 'should return false if key does not exist in redis' do
      limiter = Rate::Limiter.new('123', '/test')
      expect($redis).to receive(:exists).with(limiter.key).and_return(false)
      expect(limiter.exceeded?).to be_falsey
    end
    it 'should return false if max_requests is greater than value stored against the key' do
      limiter = Rate::Limiter.new('123', '/test')
      expect($redis).to receive(:exists).with(limiter.key).and_return(true)
      expect(Rate).to receive_message_chain(:configuration, :max_requests).and_return(5)
      expect($redis).to receive_message_chain(:get, :to_i).with(limiter.key).with(no_args).and_return(1)
      expect(limiter.exceeded?).to be_falsey
    end
    it 'should return true if max_requests is smaller than or equal to value stored against the key' do
      limiter = Rate::Limiter.new('123', '/test')
      expect($redis).to receive(:exists).with(limiter.key).and_return(true)
      expect(Rate).to receive_message_chain(:configuration, :max_requests).and_return(1)
      expect($redis).to receive_message_chain(:get, :to_i).with(limiter.key).with(no_args).and_return(1)
      expect(limiter.exceeded?).to be_truthy
    end
  end
  describe '#expiry_time' do
    it 'should return ttl of key value pair' do
      limiter = Rate::Limiter.new('123', '/test')
      expect($redis).to receive(:ttl).with(limiter.key).and_return(5)
      expect(limiter.expiry_time).to eq(5)
    end
  end
end