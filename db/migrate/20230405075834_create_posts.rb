class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string "text"
      t.string "type"
      t.string "media"
      t.timestamps
    end
  end
end
