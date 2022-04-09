require 'rails_helper'

RSpec.describe Accounts::UpdateBalanceService do
  subject(:create_service) { described_class.call(params) }

  let(:account) { create(:account, balance: 1000) }
  let(:other_account) { create(:account, balance: 1000) }
  let(:amount) { 900 }
  let(:params) do
    {
      sender_account: other_account,
      recipient_account: account,
      amount: amount
    }
  end

  describe '.update_balance!' do
    context 'when balance updating is successful' do
      it 'update users accounts balances' do
        create_service
        expect(account.reload.balance).to eq(1900)
        expect(other_account.reload.balance).to eq(100)
      end
    end

    context 'when transaction creating is not successful' do
      context "when sender doesn't have enough money for transfer" do
        let(:other_account) { create(:account, balance: 700) }

        it "doesn't update users accounts balances and creates transaction" do
          expect(create_service.errors).to eq(['Balance must be greater than or equal to 0'])
          expect(account.reload.balance).to eq(1000)
          expect(other_account.reload.balance).to eq(700)
        end
      end

      context 'when parameters is not correct' do
        let(:params) { [1, 2, 3] }

        it "doesn't update users accounts balances and creates transaction" do
          expect(create_service.errors).to eq([[:sender_account, ['is missing']],
                                               [:recipient_account, ['is missing']],
                                               [:amount, ['is missing']]])
          expect(account.reload.balance).to eq(1000)
          expect(other_account.reload.balance).to eq(1000)
        end
      end

      context 'when accounts is identical' do
        let(:params) do
          {
            sender_account: account,
            recipient_account: account,
            amount: amount
          }
        end

        it "doesn't update users accounts balances and creates transaction" do
          expect(create_service.errors).to eq(['Identical accounts'])
          expect(account.reload.balance).to eq(1000)
          expect(account.reload.balance).to eq(1000)
        end
      end
    end
  end
end
