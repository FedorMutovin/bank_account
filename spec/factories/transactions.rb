FactoryBot.define do
  factory :transaction do
    successful { true }
    sender_account_id { create(:account).id }
    recipient_account_id { create(:account).id }
    uuid { SecureRandom.hex }
  end
end
