class Panel::CreateLinkedManualPostsService
  def initialize(container, linked_manual_posts = [])
    @container = container
    @linked_manual_posts = linked_manual_posts
  end

  def call
    remove_old_links
    create_new_links
  end

  private
  def remove_old_links
    @container.linked_manual_posts.delete_all
  end

  def create_new_links
    @linked_manual_posts.each do |link|
      position = link[:position]
      manual_post = ManualPost.find_by(id: link[:manual_post_id])
      if manual_post
        @container.linked_manual_posts.create(manual_post: manual_post, position: position)
      end
    end
  end
end
