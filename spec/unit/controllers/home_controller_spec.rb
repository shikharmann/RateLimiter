require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe '#index' do
    it 'should call throttle api and return ok' do
      expect_any_instance_of(HomeController).to receive(:throttle_api).and_return('OK')
      get :index
      expect(response.body).to eq('ok')
    end
  end
end