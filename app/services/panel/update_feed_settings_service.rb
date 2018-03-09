class Panel::UpdateFeedSettingsService

  attr_reader :settings

  def initialize(source_owner, settings)
    @source_owner = source_owner
    @settings = settings
  end

  def call
    @source_owner.update_attributes(settings)
  end
end
