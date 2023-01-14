require 'rails_helper'

RSpec.describe Merchant, type: :model do
  let(:transaction) { create(:transaction) }
  let(:merchant) { transaction.merchant }

  describe 'associations' do
    it { is_expected.to belong_to(:admin).class_name('Admin') }
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe 'before_destroy' do
      context '#check_for_related_transactions' do
        it 'raise error when transtion exists' do
          expect(merchant.destroy).to be_falsey
          expect(merchant.errors.full_messages).to include('Cannot delete merchant with related transactions')
        end
      end
    end
  end

  describe 'instance_methods' do
    before do
      create_list(:authorize_transaction, 2, merchant: merchant)
      create_list(:charge_transaction, 2, merchant: merchant)
      create_list(:refund_transaction, 2, merchant: merchant)
      create_list(:reversal_transaction, 2, merchant: merchant)
    end

    context '#authorize_transactions' do
      it 'return authorize transactions' do
        expect(merchant.authorize_transactions).to all(be_an(AuthorizeTransaction))
      end
    end

    context '#charge_transactions' do
      it 'return charge transactions' do
        expect(merchant.charge_transactions).to all(be_an(ChargeTransaction))
      end
    end

    context '#refund_transactions' do
      it 'return refund transactions' do
        expect(merchant.refund_transactions).to all(be_an(RefundTransaction))
      end
    end

    context '#reversal_transactions' do
      it 'return reversal transactions' do
        expect(merchant.reversal_transactions).to all(be_an(ReversalTransaction))
      end
    end

    context '#calculate_total_transaction_sum' do
      it 'return approved charge transactions amount sum' do
        allow(merchant).to receive_message_chain('charge_transactions.approved.sum') { 5 }

        expect(merchant.calculate_total_transaction_sum).to eq(5)
      end
    end
  end
end
