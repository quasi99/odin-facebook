class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
    	t.text :body, null: false
    	t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
