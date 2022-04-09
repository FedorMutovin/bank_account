class Transactions::CreateService < ApplicationService
  attr_reader :transaction

  def initialize(params)
    super
    @sender_account = @params[:sender_account]
    @recipient_account = @params[:recipient_account]
    @amount = @params[:amount]
  end

  def process
    create_transaction!
  end

  private

  def schema
    Dry::Schema.Params do
      required(:sender_account).filled(Types.Instance(Account))
      required(:recipient_account).filled(Types.Instance(Account))
      required(:amount).filled(:float, gt?: 0)
    end
  end

  def create_transaction!
    Transaction.transaction do
      @sender_account.lock!
      @recipient_account.lock!
      start_service_in_transaction(update_accounts_balance!)
      @transaction = Transaction.create!(transaction_params)
    end
  end

  def update_accounts_balance!
    Accounts::UpdateBalanceService.call(
      sender_account: @sender_account,
      recipient_account: @recipient_account,
      amount: @amount
    )
  end

  def transaction_params
    {
      amount: @amount,
      sender_account_id: @sender_account.id,
      recipient_account_id: @recipient_account.id,
      successful: true,
      uuid: SecureRandom.uuid
    }
  end
end
