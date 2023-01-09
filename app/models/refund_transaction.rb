# frozen_string_literal: true

class RefundTransaction < Transaction
  belongs_to :charge_transaction, class_name: 'ChargeTransaction', foreign_key: 'reference_id'

  after_create :change_charge_transaction_status

  private

  def change_charge_transaction_status
    charge_transaction.update(status: 'refunded')
  end
end
