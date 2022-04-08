class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :trackable, :timeoutable
  has_one :account, dependent: :destroy

  after_create :create_account, if: -> { account.nil? }

  private

  def create_account
    Accounts::CreateService.call(id)
  end
end
