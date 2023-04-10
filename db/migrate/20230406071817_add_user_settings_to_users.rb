class AddUserSettingsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :posts_visible_to, :integer, default: 0
    add_column :users, :search_visibility, :integer, default: 0
    add_column :users, :allow_invites_from, :integer, default: 0
  end
end
