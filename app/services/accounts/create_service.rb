class Accounts::CreateService < ApplicationService
  attr_reader :account

  def initialize(params)
    super
    @user = @params[:user]
    @balance = Account::DEFAULT_BALANCE
    @bank_account = Account::BANK_ACCOUNT_DEFAULT_VALUE
    @number = SecureRandom.hex # just for example
  end

  def process
    create_account!
  end

  private

  def schema
    Dry::Schema.Params do
      required(:user).filled(Types.Instance(User))
    end
  end

  def create_account!
    return fail!('User can have only one account') if @user.account.present?

    @account = Account.new(
      balance: @balance,
      number: @number,
      user: @user,
      bank_account: @bank_account
    )

    fail!(@account.errors) unless @account.save
  end
end
