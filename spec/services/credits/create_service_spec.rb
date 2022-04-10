require 'rails_helper'

RSpec.describe Credits::CreateService do
  subject(:create_service) { described_class.call(params) }

  let(:user) { create(:user) }
  let(:account) { create(:account, balance: 1000, user: user) }
  let!(:bank_account) { create(:account, :bank) }
  let(:amount) { 900 }
  let(:params) do
    {
      user: user,
      amount: amount,
      account: account,
      bank_account: bank_account
    }
  end

  describe '.create_credit!' do
    context 'when credit creating is successful' do
      it 'creates credit' do
        expect(create_service.credit).not_to be_nil
        expect(user.credits).not_to be_empty
      end
    end

    context 'when credit creating is not successful' do
      context 'with invalid params' do
        context 'with bad params' do
          let(:params) do
            {
              user: account,
              amount: user,
              account: user
            }
          end

          it "doesn't create credit" do
            expect { create_service }.not_to change(Credit, :count)
            expect(user.credits).to eq([])
            expect(create_service.credit).to be_nil
            expect(create_service.errors).to eq([[:user, ['must be User']], [:amount, ['must be a float']],
                                                 [:account, ['must be Account']], [:bank_account, ['is missing']]])
          end
        end

        context 'with incorrect format params' do
          let(:params) { [] }

          it "doesn't create credit" do
            expect { create_service }.not_to change(Credit, :count)
            expect(user.credits).to eq([])
            expect(create_service.credit).to be_nil
            expect(create_service.errors).to eq([[:user, ['is missing']], [:amount, ['is missing']],
                                                 [:account, ['is missing']], [:bank_account, ['is missing']]])
          end
        end
      end

      context 'when bank has not enough money' do
        let!(:bank_account) { create(:account, :bank, balance: 200) }

        it "doesn't create credit" do
          expect { create_service }.not_to change(Credit, :count)
          expect(user.credits).to eq([])
          expect(create_service.credit).to be_nil
          expect(create_service.errors).to eq(['Balance must be greater than or equal to 0'])
        end
      end

      context 'when bank_account is not bank_account' do
        let!(:bank_account) { create(:account) }

        it "doesn't create credit" do
          expect { create_service }.not_to change(Credit, :count)
          expect(user.credits).to eq([])
          expect(create_service.credit).to be_nil
          expect(create_service.errors).to eq(['You can get credit only from bank account'])
        end
      end

      context 'when account is  bank_account' do
        let!(:account) { create(:account, :bank) }

        it "doesn't create credit" do
          expect { create_service }.not_to change(Credit, :count)
          expect(user.credits).to eq([])
          expect(create_service.credit).to be_nil
          expect(create_service.errors).to eq(["Bank account can't get a credit"])
        end
      end
    end
  end
end
