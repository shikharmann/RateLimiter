require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :throttle_api, only: :index
    def index
      render plain: 'ok'
    end
  end
  describe '#throttle_api' do
    it 'should set rate limiter' do
      expect(Rate::Limiter).to receive_message_chain(:new, :set).with('123', '/test').with(no_args).and_return('OK')
      @request.env['REMOTE_ADDR'] = '123'
      @request.env['REQUEST_PATH'] = '/test'
      get :index
      expect(response.body).to eq('ok')
    end
  end
end