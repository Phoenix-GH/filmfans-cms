class CreateCollectionCoverImages < ActiveRecord::Migration
  def up
    create_table :collection_cover_images do |t|
      t.string :file
      t.text :specification, default: {}.to_json
      t.references :collection, index: true, foreign_key: true

      t.timestamps
    end
    migrate_pictures
  end

  def down
    drop_table :collection_cover_images
  end

  private
  def migrate_pictures
    Collection.all.each do |collection|
      if collection.photo&.file.present?
        new_picture = CollectionCoverImage.create(collection_id: collection.id, specification: {})
        if Rails.env.development? or Rails.env.test?
          new_picture.file = collection.photo
          new_picture.save
        elsif Rails.env.production?
          new_picture.remote_file_url = collection.photo.url
          new_picture.save
        end
      end
    end
  end
end
