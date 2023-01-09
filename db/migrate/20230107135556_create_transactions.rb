class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer  :status
      t.string   :uuid
      t.float    :amount
      t.string   :customer_email
      t.string   :customer_phone
      t.integer  :reference_id
      t.integer  :merchant_id
      t.string   :type

      t.timestamps
    end
  end
end
