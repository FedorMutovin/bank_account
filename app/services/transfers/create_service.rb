class Transfers::CreateService < ApplicationService
  attr_reader :transfer

  def initialize(params)
    super
    @amount = @params[:amount]
    @sender_account = @params[:sender_account]
    @recipient_account = @params[:recipient_account]
    @category = @params[:category]
  end

  def process
    create_transfer!
  end

  private

  def schema
    Dry::Schema.Params do
      required(:sender_account).filled(Types.Instance(Account))
      required(:recipient_account).filled(Types.Instance(Account))
      required(:amount).filled(:float, gt?: 0)
      required(:category).filled(:string)
    end
  end

  def create_transfer!
    Transfer.transaction do
      @transfer = Transfer.new(transfer_params)
      fail!(@transfer.errors) unless @transfer.save
    end
  end

  def create_transaction!
    Transactions::CreateService.call(
      sender_account: @sender_account,
      recipient_account: @recipient_account,
      amount: @amount
    )
  end

  def transfer_params
    {
      amount: @amount,
      recipient_id: @recipient_account.user.id,
      sender_id: @sender_account.user.id,
      payment_transaction: start_service_in_transaction(create_transaction!).transaction,
      category: @category
    }
  end
end
