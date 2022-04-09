bank_user = User.create(email: 'bank@account.com', password: '12345678')
Account.create!(balance: 10000000000, bank_account: true, user_id: bank_user.id, number: '111111')
