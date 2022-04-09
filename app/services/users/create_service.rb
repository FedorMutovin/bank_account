class Users::CreateService < ApplicationService
  attr_reader :user

  def initialize(params)
    super
    @email = @params[:email]
    @password = @params[:password]
  end

  def process
    create_user!
  end

  private

  def schema
    Dry::Schema.Params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end
  end

  def create_user!
    @user = User.new(email: @email, password: @password)
    fail!(@user.errors) unless @user.save
  end
end
