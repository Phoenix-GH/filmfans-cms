class Panel::ToggleFeedActiveService
  def initialize(source_owner)
    @source_owner = source_owner
  end

  def call
    if @source_owner.feed_active?
      @source_owner.update_attribute(:feed_active, false)
      @source_owner.update_attribute(:dialogfeed_url, nil)      
    else
      @source_owner.update_attribute(:feed_active, true)
    end
  end
end
