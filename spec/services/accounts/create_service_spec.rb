require 'rails_helper'

RSpec.describe Accounts::CreateService do
  subject(:create_service) { described_class.call(params) }

  let(:user) { create(:user) }
  let(:params) { { user: user } }

  describe '.create_account!' do
    context 'when account creating is successful' do
      it 'create account' do
        expect { create_service }.to change(Account, :count).by(1)
      end
    end

    context 'when account creating is not successful' do
      context 'with bad params' do
        let(:params) { { user: 2 } }

        it "doesn't create account" do
          expect { create_service }.not_to change(Account, :count)
          expect(create_service.errors).to eq([[:user, ['must be User']]])
        end
      end
    end

    context 'when user already has account' do
      let!(:account) { create(:account, user: user) }

      it "doesn't create account" do
        expect { create_service }.not_to change(Account, :count)
        expect(create_service.errors).to eq(['User can have only one account'])
      end
    end
  end
end
