require 'rails_helper'

RSpec.describe "Api::V1::Transactions", type: :request do
  let(:admin) { create :admin } 
  let(:merchant) { create :merchant, admin: admin }
  let(:transaction) { create :transaction, merchant: merchant }
  let(:auth_header) { { 'Authorization' => JwtTokenService.encode(user_id: merchant.id) } }

  describe "post /transactions" do
    let(:transaction_params) do
      {
        transaction: {
          customer_email: Faker::Internet.email,
          customer_phone: Faker::PhoneNumber.cell_phone_with_country_code,
          amount: Faker::Number.decimal
        }
      }
    end
    it "contains the transaction with status Approved" do
      post api_v1_transactions_path, params: transaction_params, headers: auth_header
      expect(response).to have_http_status(:success)
      expect(Transaction.last.attributes.slice('customer_email', 'customer_phone', 'amount', 'status', 'merchant_id', 'type')).to eq(transaction_params[:transaction].merge(status: 'approved', merchant_id: merchant.id, type: 'AuthorizeTransaction').with_indifferent_access)
    end
  end

  describe "put /charge_transaction" do
    let(:authorize_transaction) { create(:authorize_transaction, merchant: merchant) }

    context 'creates charge transaction' do
      before {
        put charge_transaction_api_v1_transaction_path(authorize_transaction), headers: auth_header, params: {
          'transaction': {
            'amount': authorize_transaction.amount
          }
        }
      }

      it 'for authorize_transaction' do
        expect(authorize_transaction.charge_transactions.count).to eq(1)
      end
      it 'with approved status' do
        expect(ChargeTransaction.last.approved?).to be true
      end
      it 'with given amount' do
        expect(ChargeTransaction.last.amount).to eq(authorize_transaction.amount)
      end
    end
  end

  describe "put /refund_transaction" do
    let(:charge_transaction) { create(:charge_transaction, merchant: merchant) }
    it "contains refund transaction status as approved and update parent trasaction status as refunded" do
      expect { put refund_transaction_api_v1_transaction_path(charge_transaction), headers: auth_header, params: { 'transaction': { 'amount': 100 }} }.to change(RefundTransaction, :count).by(1)
      expect(charge_transaction.reload.refunded?).to be true
    end
  end

  describe "put /reversal_transaction" do
    let(:authorize_transaction) { create(:authorize_transaction, merchant: merchant) }
    it "contains reversal transaction status as approved and update parent trasaction status as reversed" do
      expect { put reversal_transaction_api_v1_transaction_path(authorize_transaction), headers: auth_header, params: { 'transaction': { 'status': 'approved' }} }.to change(ReversalTransaction, :count).by(1)
      expect(authorize_transaction.reload.reversed?).to be true
    end
  end
end
