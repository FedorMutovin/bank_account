class Credits::CreateService < ApplicationService
  attr_reader :credit

  def initialize(params)
    super
    @user = @params[:user]
    @amount = @params[:amount]
    @account = @params[:account]
    @bank_account = @params[:bank_account]
  end

  def process
    create_credit!
  end

  private

  def schema
    Dry::Schema.Params do
      required(:user).filled(Types.Instance(User))
      required(:amount).filled(:float, gt?: 0)
      required(:account).filled(Types.Instance(Account))
      required(:bank_account).filled(Types.Instance(Account))
    end
  end

  def create_credit!
    return fail!('You can get credit only from bank account') unless @bank_account.bank_account?
    return fail!("Bank account can't get a credit") if @account.bank_account?

    Credit.transaction do
      transaction_service = start_service_in_transaction(create_transaction!)
      @credit = Credit.create!(
        amount: @amount,
        user_id: @user.id,
        payment_transaction: transaction_service.transaction
      )
    end
  end

  def create_transaction!
    Transactions::CreateService.call(
      sender_account: @bank_account,
      recipient_account: @account,
      amount: @amount
    )
  end
end
