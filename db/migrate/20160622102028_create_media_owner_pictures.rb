class CreateMediaOwnerPictures < ActiveRecord::Migration
  def up
    create_table :media_owner_pictures do |t|
      t.string :file
      t.text :specification
      t.references :media_owner, index: true, foreign_key: true

      t.timestamps
    end
    migrate_pictures
  end

  def down
    drop_table :media_owner_pictures
  end

  private
  def migrate_pictures
    Picture.where(picture_type: 'MediaOwnerPicture').each do |old_picture|
      if old_picture.file&.file.present?
        new_picture = MediaOwnerPicture.create(
          media_owner_id: old_picture.pictureable_id,
          specification: old_picture.specification
        )
        if Rails.env.development? or Rails.env.test?
          new_picture.file = old_picture.file
          new_picture.save
        elsif Rails.env.production?
          new_picture.remote_file_url = old_picture.file.url
          new_picture.save
        end
      end
    end
  end
end