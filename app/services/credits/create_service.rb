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
      @credit = Credit.new(credit_params)
      fail!(@credit.errors) unless @credit.save
    end
  end

  def create_transfer!
    Transfers::CreateService.call(
      sender_account: @bank_account,
      recipient_account: @account,
      amount: @amount,
      category: Transfer::ALLOWED_CATEGORIES[:credit]
    )
  end

  def credit_params
    {
      amount: @amount,
      user_id: @user.id,
      transfer: start_service_in_transaction(create_transfer!).transfer
    }
  end
end
