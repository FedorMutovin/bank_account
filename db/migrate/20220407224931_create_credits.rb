class CreateCredits < ActiveRecord::Migration[7.0]
  def change
    create_table :credits do |t|
      t.float :amount, null: false
      t.references :user, foreign_key: true, index: true, null: false
      t.references :transfer, foreign_key: { to_table: :transfers }, null: false, index: true
      t.timestamps
    end
  end
end
