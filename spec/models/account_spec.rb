require 'rails_helper'

RSpec.describe Account, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many(:transactions).dependent(:destroy) }
  it { is_expected.to have_many(:transactions).dependent(:destroy).with_foreign_key('recipient_account_id') }
  it { is_expected.to validate_presence_of :number }
  it { is_expected.to validate_presence_of :balance }
  it { is_expected.not_to allow_value('sl').for(:balance) }
  it { is_expected.not_to allow_value(-1).for(:balance) }

  describe 'validate number uniqness' do
    let!(:account) { create(:account) }

    it { is_expected.to validate_uniqueness_of(:number).case_insensitive }
  end
end
