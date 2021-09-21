class CreateCommnets < ActiveRecord::Migration[6.1]
  def change
    create_table :commnets do |t|
    	t.text :body, null: false
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :commentable, null: false, polymorphic: true

      t.timestamps
    end
  end
end
