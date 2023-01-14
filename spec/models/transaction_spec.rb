require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { build(:transaction) }

  let(:authorize_transaction) { create(:authorize_transaction) }
  let(:charge_transaction) { create(:charge_transaction) }
  let(:refund_transaction) { create(:refund_transaction) }
  let(:reversal_transaction) { create(:reversal_transaction) }

  describe 'associations' do
    it { is_expected.to belong_to(:merchant) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:uuid) }
    it { is_expected.to validate_presence_of(:status) }

    context 'when type not is reversed' do
      before { allow(subject).to receive(:reversed?).and_return(false) }

      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    end

    context 'when type is reversed' do
      before { allow(subject).to receive(:is_reversed?).and_return(true) }

      it { is_expected.not_to validate_numericality_of(:amount).is_greater_than(0) }
    end
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:status).with_values(%i[approved reversed refunded error]) }
  end

  describe '.scope' do
    before do
      create_list(:authorize_transaction, 2)
      create_list(:charge_transaction, 2)
      create_list(:refund_transaction, 2)
      create_list(:reversal_transaction, 2)
    end

    it 'return authorize type transactions only' do
      expect(Transaction.authorized.pluck(:type)).to all(eq('AuthorizeTransaction'))
    end

    it 'return charge type transactions only' do
      expect(Transaction.charged.pluck(:type)).to all(eq('ChargeTransaction'))
    end

    it 'return refund type transactions only' do
      expect(Transaction.refunded.pluck(:type)).to all(eq('RefundTransaction'))
    end

    it 'return reversal type transactions only' do
      expect(Transaction.reversed.pluck(:type)).to all(eq('ReversalTransaction'))
    end
  end

  describe 'callbacks' do
    context 'after_initialize' do
      it 'set uuid' do
        expect(subject.uuid).to be_present
      end
    end
  end

  describe '.instance_methods' do
    context '.is_authorized?' do
      it 'return true when type is authorize transaction' do
        expect(authorize_transaction.is_authorized?).to be_truthy
      end
    end

    context '.is_charged?' do
      it 'return true when type is charge transaction' do
        expect(charge_transaction.is_charged?).to be_truthy
      end
    end

    context '.is_refunded?' do
      it 'return true when type is refunde transaction' do
        expect(refund_transaction.is_refunded?).to be_truthy
      end
    end

    context '.is_reversed?' do
      it 'return true when type is reverse transaction' do
        expect(reversal_transaction.is_reversed?).to be_truthy
      end
    end
  end
end
