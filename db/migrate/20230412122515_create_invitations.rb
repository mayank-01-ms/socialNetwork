class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.integer "user_id"
      t.integer "sent_to"
      t.timestamps
    end

    add_foreign_key :invitations, :users
    add_foreign_key :invitations, :users, column: :sent_to
  end
end
