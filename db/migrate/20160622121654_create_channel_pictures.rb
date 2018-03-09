class CreateChannelPictures < ActiveRecord::Migration
  def up
    create_table :channel_pictures do |t|
      t.string :file
      t.text :specification, default: {}.to_json
      t.references :channel, index: true, foreign_key: true

      t.timestamps
    end
    migrate_pictures
  end

  def down
    drop_table :channel_pictures
  end

  private
  def migrate_pictures
    Channel.all.each do |channel|
      if channel.image&.file.present?
        new_picture = ChannelPicture.create(channel_id: channel.id, specification: {})
        if Rails.env.development? or Rails.env.test?
          new_picture.file = channel.image
          new_picture.save
        elsif Rails.env.production?
          new_picture.remote_file_url = channel.image.url
          new_picture.save
        end
      end
    end
  end
end
