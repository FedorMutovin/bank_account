class AddReferencesFromTransactions < ActiveRecord::Migration[7.0]
  def change
    add_reference :credits, :payment_transaction,
                  foreign_key: { to_table: :transactions }, index: true
    add_reference :transfers, :payment_transaction,
                  foreign_key: { to_table: :transactions }, index: true
  end
end
