require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one :account }
  it { is_expected.to have_many :credits }
  it { is_expected.to have_many(:transfers).dependent(:destroy) }
  it { is_expected.to have_many(:transfers).dependent(:destroy).with_foreign_key('recipient_id') }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.not_to allow_value('79').for(:email) }

  describe 'create_account' do
    let!(:user) { create(:user) }

    it 'creates account after user was created' do
      expect(user.reload.account).not_to be_nil
    end
  end
end
