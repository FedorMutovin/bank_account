class TransfersController < ApplicationController
  before_action :recipient_account, only: %i[create]

  def new; end

  def create
    if @recipient_account.nil? || transfer_service.failure?
      redirect_to new_transfer_path, notice: "Transfer didn't send"
    else
      redirect_to root_path, notice: 'Transfer was sent'
    end
  end

  private

  def transfer_service
    @transfer_service ||= Transfers::CreateService.call(
      sender_account: current_user.account,
      recipient_account: @recipient_account,
      amount: params[:amount].to_f,
      category: Transfer::ALLOWED_CATEGORIES[:transfer]
    )
  end

  def recipient_account
    @recipient_account ||= Account.find_by(number: params[:number])
  end
end
