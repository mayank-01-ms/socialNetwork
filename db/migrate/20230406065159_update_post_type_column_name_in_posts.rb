class UpdatePostTypeColumnNameInPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :type
    add_column :posts, :post_type, :string
  end
end
