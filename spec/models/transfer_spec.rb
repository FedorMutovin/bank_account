require 'rails_helper'

RSpec.describe Transfer, type: :model do
  it_behaves_like 'amount_validation'
  it { is_expected.to belong_to :sender }
  it { is_expected.to belong_to :recipient }
  it { is_expected.to belong_to :payment_transaction }
  it { is_expected.to validate_presence_of :category }
  it { is_expected.to validate_inclusion_of(:category).in_array(Transfer::ALLOWED_CATEGORIES.values) }
  it { is_expected.to have_one(:credit).dependent(:destroy) }
end
