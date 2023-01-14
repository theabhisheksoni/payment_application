# frozen_string_literal: true

class ReversalTransaction < Transaction
  belongs_to :authorize_transaction, class_name: 'AuthorizeTransaction',
                                     inverse_of: :reversal_transactions,
                                     foreign_key: 'reference_id'

  after_save :change_authorize_transaction_status

  private

  def change_authorize_transaction_status
    authorize_transaction.update(status: 'reversed')
  end
end
