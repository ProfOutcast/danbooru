class CreateLinkedAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :linked_accounts do |t|
      t.timestamps
      t.integer :user_id, null: false
      t.integer :site, null: false
      t.string :account_id, null: false
      t.jsonb :api_key, null: false
      t.jsonb :account_data, null: false

      t.index :user_id
      t.index :site
      t.index :account_id
      t.index :api_key, using: :gin
      t.index :account_data, using: :gin
      t.index [:site, :user_id], unique: true
      t.index [:site, :account_id], unique: true
    end
  end
end
