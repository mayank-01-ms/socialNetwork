class AddIsPrivateToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :is_private, :boolean, :default => false
  end
end
