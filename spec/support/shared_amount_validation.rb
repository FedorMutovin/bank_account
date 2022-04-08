require 'rails_helper'

RSpec.shared_examples 'amount_validation' do
  it { is_expected.to validate_presence_of :amount }
  it { is_expected.not_to allow_value('sl').for(:amount) }
  it { is_expected.not_to allow_value(0).for(:amount) }
end
