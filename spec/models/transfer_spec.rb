require 'rails_helper'

RSpec.describe Transfer, type: :model do
  it_behaves_like 'amount_validation'
  it { is_expected.to belong_to :sender }
  it { is_expected.to belong_to :recipient }
end
