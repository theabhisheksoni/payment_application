require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  let(:admin) { create :admin } 
  let(:merchant) { create :merchant, admin: admin }
  let(:transaction) { create :transaction, merchant: merchant }

  before(:each) do
    login_as admin
  end

  describe "GET /index" do
    it 'should return the successful status' do
      get merchant_transactions_path(merchant)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "should return the successful status" do
      get merchant_transaction_path(merchant, transaction)
      expect(response).to render_template('transactions/show')
    end
  end

end
