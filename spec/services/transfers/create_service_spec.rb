require 'rails_helper'

RSpec.describe Transfers::CreateService do
  subject(:create_service) { described_class.call(params) }

  let(:sender_account) { create(:account, balance: 1000) }
  let(:recipient_account) { create(:account, balance: 1000) }
  let(:amount) { 900 }
  let(:params) do
    {
      sender_account: sender_account,
      recipient_account: recipient_account,
      amount: amount,
      category: Transfer::ALLOWED_CATEGORIES[:transfer]
    }
  end

  describe '.create_transfer!' do
    context 'when transfer creating is successful' do
      it 'creates transfer' do
        expect(create_service.transfer).not_to be_nil
        expect(sender_account.user.transfers).not_to be_empty
        expect(recipient_account.user.transfers).not_to be_empty
      end
    end

    context 'when transfer creating is not successful' do
      context 'with invalid params' do
        context 'with bad params' do
          let(:params) do
            {
              sender_account: '',
              recipient_account: amount,
              amount: sender_account
            }
          end

          it "doesn't create transfer" do
            expect { create_service }.not_to change(Transfer, :count)
            expect(create_service.transfer).to be_nil
            expect(create_service.errors).to eq([[:sender_account, ['must be filled']],
                                                 [:recipient_account, ['must be Account']],
                                                 [:amount, ['must be a float']],
                                                 [:category, ['is missing']]])
          end
        end

        context 'with incorrect format params' do
          let(:params) { [] }

          it "doesn't create transfer" do
            expect { create_service }.not_to change(Credit, :count)
            expect(create_service.transfer).to be_nil
            expect(create_service.errors).to eq([[:sender_account, ['is missing']],
                                                 [:recipient_account, ['is missing']],
                                                 [:amount, ['is missing']],
                                                 [:category, ['is missing']]])
          end
        end
      end

      context 'when sender has not enough money' do
        let(:sender_account) { create(:account, balance: 200) }

        it "doesn't create credit" do
          expect { create_service }.not_to change(Credit, :count)
          expect(create_service.transfer).to be_nil
          expect(create_service.errors).to eq(['Balance must be greater than or equal to 0'])
        end
      end
    end
  end
end
