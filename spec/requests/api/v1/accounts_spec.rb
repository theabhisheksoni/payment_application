require 'rails_helper'

RSpec.describe 'Api::V1::Accounts', type: :request do
  let(:merchant) { create :merchant }
  let(:token) { JwtTokenService.encode(user_id: merchant.id) }

  describe '#authentication' do
    context 'valid credentials' do
      let(:auth_params) do
        {
          email: merchant.email,
          password: merchant.password
        }
      end
      it 'generates token' do
        post api_v1_authenticate_path, params: auth_params
        expect(json_response(response)['access_token']).to eq(token)
      end
    end

    context 'invalid credentials' do
      let(:auth_params) do
        {
          email: Faker::Internet.email,
          password: 'wrong_password'
        }
      end
      it 'returns error' do
        post api_v1_authenticate_path, params: auth_params
        expect(json_response(response)).to eq({ error: 'Unauthorized' }.with_indifferent_access)
      end
    end
  end
end
