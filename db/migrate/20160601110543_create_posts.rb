class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :source, index: true

      t.datetime :post_created_at
      t.string :content_title
      t.text :content_body
      t.string :content_picture
      t.string :content_video_url
      t.string :post_url

      t.timestamps null: false
    end
  end
end
