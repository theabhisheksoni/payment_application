require 'rails_helper'

RSpec.describe ReversalTransaction, type: :model do
  it 'instance of transaction' do
    expect(subject).to be_an(Transaction)
  end

  describe 'associations' do
    it do
      is_expected.to belong_to(:authorize_transaction).class_name('AuthorizeTransaction').with_foreign_key('reference_id')
    end
  end

  describe 'callbacks' do
    it do
      is_expected.to belong_to(:authorize_transaction).class_name('AuthorizeTransaction').with_foreign_key('reference_id')
    end
  end
end
