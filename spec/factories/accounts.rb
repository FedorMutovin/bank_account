FactoryBot.define do
  factory :account do
    user_id { create(:user).id }
    number { SecureRandom.hex }
    balance { 0 }
    bank_account { false }

    trait :bank do
      balance { 100_000_000_000 }
      bank_account { true }
    end
  end
end
