class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.float :amount, null: false
      t.string :category, null: false, index: true
      t.references :sender, foreign_key: { to_table: :users }, index: true, null: false
      t.references :recipient, foreign_key: { to_table: :users }, index: true, null: false
      t.references :payment_transaction, foreign_key: { to_table: :transactions }, null: false, index: true

      t.timestamps
    end
  end
end
