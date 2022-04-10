require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { is_expected.to belong_to :sender_account }
  it { is_expected.to belong_to :recipient_account }
  it { is_expected.to validate_presence_of :successful }
  it { is_expected.to validate_presence_of :uuid }
  it { is_expected.to have_one(:transfer).dependent(:destroy).with_foreign_key('payment_transaction_id') }

  describe 'validate uuid uniqness' do
    let!(:transaction) { create(:transaction) }

    it { is_expected.to validate_uniqueness_of(:uuid).case_insensitive }
  end
end
