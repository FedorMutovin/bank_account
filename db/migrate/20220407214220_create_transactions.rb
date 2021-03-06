class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :uuid, null: false
      t.string :successful, null: false, default: false
      t.references :sender_account, foreign_key: { to_table: :accounts }, index: true, null: false
      t.references :recipient_account, foreign_key: { to_table: :accounts }, index: true, null: false

      t.timestamps
    end
    add_index :transactions, :uuid, unique: true
  end
end
