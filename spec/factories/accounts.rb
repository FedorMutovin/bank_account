FactoryBot.define do
  factory :account do
    user_id { create(:user).id }
    number { SecureRandom.hex }
    balance { 0 }
  end
end
