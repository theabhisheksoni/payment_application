class TransactionsCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Transaction.where('created_at < ?', 1.hour.ago).destroy_all
  end
end
