require 'rails_helper'

RSpec.describe Transactions::CreateService do
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

  describe '.create_transaction!' do
    context 'when transaction creating is successful' do
      it 'creates transaction' do
        expect { create_service }.to change(Transaction, :count).by(1)
        expect(account.transactions.first.successful).to be_truthy
        expect(other_account.transactions.first.successful).to be_truthy
        expect(create_service.transaction).not_to be_nil
      end
    end

    context 'when transaction creating is not successful' do
      context "when sender doesn't have enough money for transfer" do
        let(:other_account) { create(:account, balance: 700) }

        it "doesn't creates transaction" do
          expect { create_service }.not_to change(Transaction, :count)
          expect(create_service.errors).to eq(['Balance must be greater than or equal to 0'])
          expect(create_service.transaction).to be_nil
        end
      end

      context 'when parameters is not correct' do
        let(:params) { [1, 2, 3] }

        it "doesn't creates transaction" do
          expect { create_service }.not_to change(Transaction, :count)
          expect(create_service.transaction).to be_nil
          expect(create_service.errors).to eq([[:sender_account, ['is missing']],
                                               [:recipient_account, ['is missing']],
                                               [:amount, ['is missing']]])
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

        it "doesn't creates transaction" do
          expect { create_service }.not_to change(Transaction, :count)
          expect(create_service.errors).to eq(['Identical accounts'])
          expect(create_service.transaction).to be_nil
        end
      end
    end
  end
end
