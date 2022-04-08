class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.float :amount, null: false
      t.string :successful, null: false, default: false
      t.references :sender_account, foreign_key: { to_table: :accounts }, index: true, null: false
      t.references :recipient_account, foreign_key: { to_table: :accounts }, index: true, null: false

      t.timestamps
    end
  end
end
