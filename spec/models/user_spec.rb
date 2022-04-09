require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one :account }
  it { is_expected.to have_many :credits }
  it { is_expected.to have_many(:transfers).dependent(:destroy) }
  it { is_expected.to have_many(:transfers).dependent(:destroy).with_foreign_key('recipient_id') }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.not_to allow_value('79').for(:email) }

  describe 'self.create_with_account(params)' do
    it 'creates User with Account' do
      result = described_class.create_with_account(email: 'test@user.com', password: '12345678')
      expect(result).is_a?(Array)
      expect(result.first).to be_an_instance_of(described_class)
      expect(result.second).to be_an_instance_of(Account)
      expect(described_class.count).to eq(1)
      expect(Account.count).to eq(1)
    end

    context 'when user already created' do
      let!(:user) { create(:user, email: 'test@user.com') }

      it 'creates User with Account' do
        result = described_class.create_with_account(email: 'test@user.com', password: '12345678')
        expect(result).to be_nil
        expect(described_class.count).to eq(1)
        expect(Account.count).to be_zero
      end
    end
  end

  describe 'get_credit' do
    let!(:account) { create(:account) }
    let!(:bank_account) { create(:account, :bank) }

    it 'creates credit and return Credit' do
      result = account.user.get_credit(100)
      expect(result).to be_an_instance_of(Credit)
      expect(account.reload.balance).to eq(100)
    end

    it "doesn't creates credit and return errors" do
      result = bank_account.user.get_credit(100)
      expect(result).not_to be_an_instance_of(Credit)
      expect(result).to eq(["Bank account can't get a credit"])
      expect(account.reload.balance).to eq(0)
    end
  end
end
