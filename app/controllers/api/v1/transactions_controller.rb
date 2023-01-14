module Api
  module V1
    class TransactionsController < ApplicationController
      skip_before_action :verify_authenticity_token
      include ApiAuthenticationHandler

      before_action :authenticate_api_request!
      before_action :set_parent_transaction, :set_status,
                    only: %i[charge_transaction refund_transaction reversal_transaction]
      before_action :check_merchant_status

      def create
        transaction = AuthorizeTransaction.new(transaction_params)
        if transaction.save
          json_response(transaction.as_json, 200)
        else
          json_response(transaction.errors.as_json, 400)
        end
      end

      def charge_transaction
        if @parent_transaction.is_authorized?
          charge_transaction = @parent_transaction.charge_transactions.new(update_transaction_params.merge(status: @status))
          if charge_transaction.save
            json_response(charge_transaction.as_json, 200)
          else
            json_response(charge_transaction.errors.as_json, 400)
          end
        else
          json_response({ error: 'Authorize transaction with approved status required' }, 400)
        end
      end

      def refund_transaction
        if @parent_transaction.is_charged?
          refund_transaction = @parent_transaction
                               .refund_transactions
                               .new(update_transaction_params.merge(status: @status))
          if refund_transaction.save
            json_response(refund_transaction.as_json, 200)
          else
            json_response(refund_transaction.errors.as_json, 400)
          end
        else
          json_response({ error: 'Charge transaction with approved status required' }, 400)
        end
      end

      def reversal_transaction
        if @parent_transaction.is_authorized?
          reversal_transaction = @parent_transaction
                                 .reversal_transactions
                                 .new(parent_attributes.merge(status: @status))
          if reversal_transaction.save
            json_response(reversal_transaction.as_json, 200)
          else
            json_response(reversal_transaction.errors.as_json, 400)
          end
        else
          json_response({ error: 'Authorize transaction with approved status  required' }, 400)
        end
      end

      private

      def check_merchant_status
        return true if current_user.active?

        json_response({ error: 'Merchant must be active to create a transaction.' }, 400)
      end

      def set_parent_transaction
        @parent_transaction = current_user.transactions.find_by(id: params[:id])
      end

      def transaction_params
        params.require(:transaction)
              .permit(:amount, :customer_email, :customer_phone)
              .merge(merchant_id: current_user.id, status: 'approved')
      end

      def update_transaction_params
        params.require(:transaction).permit(:amount).merge(parent_attributes)
      end

      def parent_attributes
        @parent_transaction.attributes.slice('customer_email', 'customer_phone', 'merchant_id')
      end

      def set_status
        @status = @parent_transaction.can_be_referenced? ? 'approved' : 'error'
      end
    end
  end
end
