require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_one :account }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.not_to allow_value('79').for(:email) }
end
