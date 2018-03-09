class RemovePictureAndBackgroundImageFromMediaOwners < ActiveRecord::Migration

  class TempMediaOwner < MediaOwner
    mount_uploader :picture, PictureUploader
    mount_uploader :background_image, PictureUploader
  end

  def up
    migrate_media_owners_pictures
    remove_column :media_owners, :picture
    remove_column :media_owners, :background_image
  end

  def down
    add_column :media_owners, :picture, :string
    add_column :media_owners, :background_image, :string
  end

  private
  def migrate_media_owners_pictures
    TempMediaOwner.all.each do |mo|
      if mo.picture&.file&.file.present?
        if Rails.env.development? or Rails.env.test?
          Picture.create(
            picture_type: 'MediaOwnerPicture',
            pictureable_type: 'MediaOwner',
            pictureable_id: mo.id,
            file: mo.picture,
          )
        elsif Rails.env.production?
          Picture.create(
            picture_type: 'MediaOwnerPicture',
            pictureable_type: 'MediaOwner',
            pictureable_id: mo.id,
            remote_file_url: mo.picture.url,
          )
        end
      end

      if mo.background_image&.file&.file.present?
        if Rails.env.development? or Rails.env.test?
          Picture.create(
            picture_type: 'MediaOwnerBackgroundImage',
            pictureable_type: 'MediaOwner',
            pictureable_id: mo.id,
            file: mo.background_image,
          )
        elsif Rails.env.production?
          Picture.create(
            picture_type: 'MediaOwnerBackgroundImage',
            pictureable_type: 'MediaOwner',
            pictureable_id: mo.id,
            remote_file_url: mo.background_image.url,
          )
        end
      end
    end
  end
end
