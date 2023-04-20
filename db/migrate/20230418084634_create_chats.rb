class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.integer "user_id"
      t.integer "from"
      t.timestamps
    end

    add_foreign_key :chats, :users
    add_foreign_key :chats, :users, column: :from

    add_index :chats, [:user_id, :from], unique: true
  end
end
