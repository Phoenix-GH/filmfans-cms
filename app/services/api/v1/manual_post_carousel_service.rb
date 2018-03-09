class Api::V1::ManualPostCarouselService

  def list_media_owner_having_manual_posts(current_user = nil)
    media_owner_ids = media_owner_trendings.map { |manual_post| manual_post.media_owner.id }
    media_owners = MediaOwnerQuery.new({media_owner_ids: media_owner_ids.uniq, feed_active: true}).results
    media_owners.map { |res| MediaOwnerSerializer.new(res, false, current_user).results }
  end

  def media_owner_trendings
    ManualPost
        .unscoped # ignore default scope
        .select(:media_owner_id).distinct
        .where.not(media_owner_id: nil)
        .where.not(display_option: ManualPost::DISPLAY_SOCIAL_ONLY)
  end
end