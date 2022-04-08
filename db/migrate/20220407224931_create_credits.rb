class CreateCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :credits do |t|
      t.float :amount, null: false
      t.references :account, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
