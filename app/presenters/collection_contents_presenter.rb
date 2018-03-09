class CollectionContentsPresenter
  def initialize(current_admin)
    @current_admin = current_admin
  end

  def media_containers
    media_containers = MediaContainerQuery.new(search_params).results
    media_containers.select(:name, :id)
  end

  def products_containers
    products_containers = ProductsContainerQuery.new(search_params).results
    products_containers.select(:name, :id)
  end

  def combo_containers
    combo_containers = ProductsContainerQuery.new(search_params.merge(with_media_owner: true)).results
    combo_containers.select(:name, :id)
  end

  private

  def search_params
    if @current_admin.role == Role::Moderator
      {}
      .merge(channel_ids: @current_admin.channel_ids)
      .merge(media_owner_ids: @current_admin.media_owner_ids)
    else
      {}
    end
  end
end
