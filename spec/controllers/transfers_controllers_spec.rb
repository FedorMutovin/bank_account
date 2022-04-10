require 'rails_helper'

RSpec.describe TransfersController, type: :controller do
  describe 'POST #create' do
    let!(:account) { create(:account, balance: 1000) }
    let!(:other_account) { create(:account, balance: 1000) }

    context 'with valid attributes' do
      before { sign_in(account.user) }

      it 'saves a new transfer in the database' do
        expect do
          post :create, params: { number: other_account.number,
                                  amount: 100 }
        end.to change(Transfer, :count).by(1)
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      before { sign_in(account.user) }

      context 'with invalid amount' do
        it "doesn't saves a new transfer in the database" do
          expect do
            post :create, params: { number: other_account.number,
                                    amount: 0 }
          end.not_to change(Transfer, :count)
          expect(response).to redirect_to new_transfer_path
        end
      end

      context 'with the same account' do
        it "doesn't saves a new transfer in the database" do
          expect do
            post :create, params: { number: account.number,
                                    amount: 100 }
          end.not_to change(Transfer, :count)
          expect(response).to redirect_to new_transfer_path
        end
      end
    end

    context 'without login' do
      it "doesn't saves a new transfer in the database" do
        expect do
          post :create, params: { number: other_account.number,
                                  amount: 100 }
        end.not_to change(Transfer, :count)
        expect(response).to redirect_to user_session_path
      end
    end

    context "when user doesn't have account" do
      let!(:user) { create(:user) }

      it "doesn't saves a new transfer in the database" do
        sign_in(user)
        expect do
          post :create, params: { number: other_account.number,
                                  amount: 100 }
        end.not_to change(Transfer, :count)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET #new' do
    let!(:user) { create(:user) }

    context "when user doesn't have account" do
      it "doesn't redirect to new_transfer_path" do
        sign_in(user)
        expect(get(:new)).to redirect_to root_path
      end
    end
  end
end
