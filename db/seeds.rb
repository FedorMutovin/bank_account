bank_user = User.create(email: 'bank@account.com', password: '12345678')
Account.find_by(user_id: bank_user&.id)&.update(balance: 100000000000000.0)
