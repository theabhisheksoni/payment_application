# frozen_string_literal: true

class ChargeTransaction < Transaction
  belongs_to :authorize_transaction, class_name: 'AuthorizeTransaction',
                                     inverse_of: :charge_transactions,
                                     foreign_key: 'reference_id'
  has_many :refund_transactions, class_name: 'RefundTransaction',
                                 foreign_key: 'reference_id',
                                 inverse_of: :charge_transaction,
                                 dependent: :destroy

  after_save :update_merchant_total_transaction

  private

  def update_merchant_total_transaction
    merchant.total_transaction_sum = merchant.calculate_total_transaction_sum
    merchant.save
  end
end
