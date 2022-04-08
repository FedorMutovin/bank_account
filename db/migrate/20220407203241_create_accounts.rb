class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :number, null: false
      t.float :balance, null: false, default: 0
      t.references :user, foreign_key: true, null: false, index: true

      t.timestamps
    end
    add_index :accounts, :number, unique: true
  end
end
