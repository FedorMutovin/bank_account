require 'rails_helper'

RSpec.describe Users::CreateService do
  subject(:create_service) { described_class.call(params) }

  let(:params) do
    {
      email: 'test@user.com',
      password: '12345678'
    }
  end

  describe '.create_user!' do
    context 'when user creating is successful' do
      it 'create account' do
        expect { create_service }.to change(User, :count).by(1)
      end
    end

    context 'when account creating is not successful' do
      context 'with bad params' do
        let(:params) { { email: 2 } }

        it "doesn't create account" do
          expect { create_service }.not_to change(User, :count)
          expect(create_service.errors).to eq([[:email, ['must be a string']], [:password, ['is missing']]])
        end
      end
    end

    context 'when user already has account' do
      let!(:user) { create(:user, email: 'test@user.com', password: '12345678') }

      it "doesn't create account" do
        expect { create_service }.not_to change(User, :count)
        expect(create_service.errors).to eq(['Email has already been taken'])
      end
    end
  end
end
