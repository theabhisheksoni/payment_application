class Merchant < User
  belongs_to :admin, class_name: 'Admin'
  has_many :transactions, dependent: :destroy
  before_destroy :check_for_related_transactions

  def authorize_transactions
    transactions.authorized
  end

  def charge_transactions
    transactions.charged
  end

  def refund_transactions
    transactions.refunded
  end

  def reversal_transactions
    transactions.reversed
  end

  def calculate_total_transaction_sum
    charge_transactions.approved.sum(:amount)
  end

  private

  def check_for_related_transactions
    return true if transactions.none?
  
    errors.add(:base, 'Cannot delete merchant with related transactions')
    throw :abort
  end
end
