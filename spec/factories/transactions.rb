FactoryBot.define do
  factory :transaction do
    status { 'approved' }
    customer_email { Faker::Internet.email }
    customer_phone { Faker::PhoneNumber.cell_phone_with_country_code }
    amount { Faker::Number.decimal }
    merchant
  end

  factory :authorize_transaction, parent: :transaction, class: AuthorizeTransaction do
  end

  factory :charge_transaction, parent: :transaction, class: ChargeTransaction do
    authorize_transaction
    merchant { authorize_transaction.merchant }
  end

  factory :refund_transaction, parent: :transaction, class: RefundTransaction do
    charge_transaction
    merchant { charge_transaction.merchant }
  end

  factory :reversal_transaction, parent: :transaction, class: ReversalTransaction do
    amount { nil }
    authorize_transaction
    merchant { authorize_transaction.merchant }
  end
end
