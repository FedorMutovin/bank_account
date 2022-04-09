require 'rails_helper'

RSpec.describe Credit, type: :model do
  it_behaves_like 'amount_validation'
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :payment_transaction }
end
