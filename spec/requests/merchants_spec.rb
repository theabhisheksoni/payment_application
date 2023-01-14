require 'rails_helper'

RSpec.describe "Merchants", type: :request do

  let(:admin) { create :admin } 
  let(:merchant) { create :merchant, admin: admin } 

  before(:each) do
    login_as admin
  end

  describe "GET /merchants" do
    it 'should return the successful status' do
      get merchants_path
      expect(response).to be_successful
    end
  end

  describe "show merchant" do
    it 'should return the status code 200' do 
      get merchant_path(merchant)
      expect(response).to render_template('merchants/show')
    end
  end

  describe "edit merchants" do
    it 'should return the status code 200' do 
      get edit_merchant_path(merchant)
      expect(response).to render_template('merchants/_form')
    end
  end

  describe "update merchants" do
    it 'should return the status code 200' do 
      put merchant_url(merchant), params: {
        merchant: {
          email: 'test@example.com',
          name: 'Test'
        }
      }
      expect(response).to redirect_to(merchant_url(merchant))
    end
  end

  describe "destroy merchants" do
    it 'should return the status code 200' do 
      delete merchant_url(merchant)
      expect(response).to redirect_to(merchants_url)
    end
  end
end
