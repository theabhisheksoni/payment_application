# frozen_string_literal: true

class AuthorizeTransaction < Transaction
  has_many :charge_transactions, class_name: 'ChargeTransaction', foreign_key: 'reference_id'
  has_many :reversal_transactions, class_name: 'ReversalTransaction', foreign_key: 'reference_id'
end
