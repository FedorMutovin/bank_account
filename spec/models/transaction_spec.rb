require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it_behaves_like 'amount_validation'
  it { is_expected.to belong_to :sender_account }
  it { is_expected.to belong_to :recipient_account }
  it { is_expected.to validate_presence_of :successful }
end
