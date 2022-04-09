FactoryBot.define do
  factory :transaction do
    amount { 1 }
    successful { true }
    sender_account_id { create(:account).id }
    recipient_account_id { create(:account).id }
    uuid { SecureRandom.hex }
  end
end
