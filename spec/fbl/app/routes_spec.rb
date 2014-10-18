require 'spec_helper'
require 'fbl/app/routes'
require 'rack/test'

describe Fbl::App do
  include Rack::Test::Methods

  def app
    described_class
  end

  context '#post' do
    let(:user) { double(:user, id: '2') }

    before do
      allow_any_instance_of(described_class).to receive(:authenticate_user)
      allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
      allow_any_instance_of(described_class).to receive(:invalid_prediction_indexes).and_return(invalid_predictions)
    end


    context 'valid prediction' do

      let(:invalid_predictions) { [] }

      it 'should return success status code' do
        post('/predictions', {}.to_json)
        expect(last_response.status).to eq(200)
      end

      it 'should return successful json' do
        post('/predictions', {}.to_json)
        expect(last_response.body).to eq({success: true}.to_json)
      end
    end

    context 'invalid prediction' do

      let(:invalid_predictions) { [1] }

      it 'should return success status code' do
        post('/predictions', {}.to_json)
        expect(last_response.status).to eq(200)
      end

      it 'should return failure json' do
        post('/predictions', {}.to_json)
        expect(last_response.body).to eq({success: false, invalid_predictions_indexes: invalid_predictions}.to_json)
      end

    end
  end

end

