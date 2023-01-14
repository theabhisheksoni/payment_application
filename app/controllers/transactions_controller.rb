class TransactionsController < ApplicationController
  before_action :set_merchant

  def index
    @transactions = @merchant.transactions
  end

  def show
    @transaction = @merchant.transactions.find(params[:id])
  end

  private

  def set_merchant
    @merchant = current_user.merchants.find_by(id: params[:merchant_id])
  end
end
