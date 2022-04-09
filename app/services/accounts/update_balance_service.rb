class Accounts::UpdateBalanceService < ApplicationService
  def initialize(params)
    super
    @sender_account = @params[:sender_account]
    @recipient_account = @params[:recipient_account]
    @amount = @params[:amount]
  end

  def process
    update_balance!
  end

  private

  def schema
    Dry::Schema.Params do
      required(:sender_account).filled(Types.Instance(Account))
      required(:recipient_account).filled(Types.Instance(Account))
      required(:amount).filled(:float, gt?: 0)
    end
  end

  def update_balance!
    return fail!('Identical accounts') if identical_accounts?

    @sender_account.balance -= @amount
    @recipient_account.balance += @amount

    return fail!(@sender_account.errors) unless @sender_account.save

    fail!(@recipient_account.errors) unless @recipient_account.save
  end

  def identical_accounts?
    @sender_account.id.eql?(@recipient_account.id)
  end
end
