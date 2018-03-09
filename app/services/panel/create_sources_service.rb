class Panel::CreateSourcesService

  def initialize(source_owner, dialogfeed_sources)
    @source_owner = source_owner
    @dialogfeed_sources = dialogfeed_sources
  end

  def call
    [@dialogfeed_sources].flatten.each do |source|

      # Check if website is allowed
      website = source['type']
      next unless website.in? Source.allowed_websites

      # Check if source does not already exist
      dialogfeed_id = source['id']
      next if @source_owner.sources.where(dialogfeed_id: dialogfeed_id).any?

      name = source['name']

      # Create source
      @source_owner.sources.create(name: name, dialogfeed_id: dialogfeed_id, website: website)
    end
  end

end
