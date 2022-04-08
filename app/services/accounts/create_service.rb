class Accounts::CreateService
  def initialize(user_id)
    @user_id = user_id
    @number = SecureRandom.hex
    @default_balance = 0
  end

  def call
    create_account!
    self
  end

  private

  def create_account!
    Account.create(number: @number, balance: @default_balance, user_id: @user_id)
  end
end