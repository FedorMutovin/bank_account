## About
Simple bank app where you can get credit to your balance and send money to other users
## Things to do
* cp database.yml.example database.yml
* run bin/rails db:seed to create bank user account, who can give you a credit
* rspec - run specs
## General info
This project has instances:
* User - may have account, credit, transfers
* Account - account with balance, has user, may have transactions 
* Credit - has user and transfer
* Transfer - has 2 users, sender & recipient , may have Credit, has transaction
* Transaction - has 2 accounts, sender_account & recipient_account and also transfer

### User creating
You can create user with bank account only via console, use  User.create_with_account(email, password) method for this.

#### Example: User.create_with_account(email: 'user@user.user', password: '123')

##### Password & Email must be string.

### #get_credit()

This method allows you to get credit via console from bank, make sure that bank user account has already created.

#### Example: User.find_by(email: 'user@user.user').get_credit(10000)

### Money transfering

You can send money to other user from UI, just use Send money to other user link button
