class UsersController < ApplicationController
  def show
    @account = current_user.account
    @transfers = current_user.transfers
  end
end
