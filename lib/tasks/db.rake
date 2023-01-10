namespace :db do
  desc 'Delete transactions older than an hour'
  task transaction_cleanup: :environment do
    TransactionsCleanupJob.perform_later
  end
end
